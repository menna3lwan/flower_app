import 'package:injectable/injectable.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/jwt_payload_decoder.dart';
import '../../api/auth_api_service.dart';
import '../models/auth_api_envelope.dart';
import 'auth_local_data_source.dart';

/// Marker interface distinguishing "the real backend" from
/// [AuthLocalDataSource]'s simulated implementation at the DI/type level,
/// while remaining structurally interchangeable with it (same methods —
/// see the NOTE on [AuthLocalDataSource]). `AuthRepositoryImpl` keeps
/// depending on [AuthLocalDataSource]; DI decides which concrete class —
/// [AuthLocalDataSourceImpl] or [AuthRemoteDataSourceImpl] — it receives.
abstract interface class AuthRemoteDataSource
    implements AuthLocalDataSource {}

/// Talks to the real FlowersApp.Auth backend through `AuthApiService`
/// (Retrofit) instead of the previous hand-rolled `ApiClient` calls.
///
/// Every path/request/response shape here is taken from the live
/// backend's own Swagger document (`docker/auth-swagger.json` /
/// `swagger1.json`) and cross-checked with real curl calls through the
/// Gateway — nothing here is guessed. See `core/network/api_endpoints.dart`
/// for the confirmed path list and `docs/BACKEND_INTEGRATION_TODO.md` for
/// the one open ambiguity (the Gender 1/2 wire mapping).
///
/// This class only ever *throws* on failure — a `DioException` from
/// Retrofit/Dio, or one of the Auth-specific exceptions below — it never
/// returns a `Result` itself. Converting those exceptions into a
/// `Result<Failure>` is `AuthRepositoryImpl`'s job, via `safeCall`
/// (`core/base/safe_call.dart`) and `ErrorParser`
/// (`core/network/error_parser.dart`), so this class stays a pure "talk
/// to the network and hand back a domain-shaped value or throw" data
/// source.
@LazySingleton(as: AuthLocalDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiService, this._secureStorage);

  final AuthApiService _apiService;
  final SecureStorageService _secureStorage;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final json = await _apiService.login({'email': email, 'password': password});
    final envelope = AuthApiEnvelope.fromJson(json);
    _throwIfEnvelopeFailed(envelope);
    return _persistSessionAndBuildUser(envelope.dataAsMap, fallbackEmail: email);
  }

  @override
  Future<UserEntity> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required Gender gender,
  }) async {
    final json = await _apiService.signUp({
      'fullName': '$firstName $lastName'.trim(),
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender.apiValue,
      'password': password,
      'confirmPassword': confirmPassword,
    });
    final envelope = AuthApiEnvelope.fromJson(json);
    _throwIfEnvelopeFailed(envelope);

    // Register only returns the new user's id (`GuidApiResponse`) — no
    // token, no echoed profile — so the rest of the entity is built from
    // what the caller already submitted, not invented.
    return UserEntity(
      id: envelope.dataAsString,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      gender: gender,
    );
  }

  @override
  Future<UserEntity> continueAsGuest() async {
    await _secureStorage.clearSession();
    return const UserEntity(
      id: 'guest',
      firstName: 'Guest',
      lastName: '',
      email: '',
      isGuest: true,
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    final json = await _apiService.forgotPassword({'email': email});
    _throwIfEnvelopeFailed(AuthApiEnvelope.fromJson(json));
  }

  @override
  Future<String> verifyCode({
    required String email,
    required String code,
  }) async {
    final json = await _apiService.verifyOtp({'email': email, 'otp': code});
    final envelope = AuthApiEnvelope.fromJson(json);
    _throwIfEnvelopeFailed(envelope);
    return envelope.dataAsMap['resetToken'] as String? ?? '';
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final json = await _apiService.resetPassword({
      'resetToken': resetToken,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword,
    });
    _throwIfEnvelopeFailed(AuthApiEnvelope.fromJson(json));
  }

  @override
  Future<void> refreshSession() async {
    final storedRefreshToken = await _secureStorage.readRefreshToken();
    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      // Nothing to refresh with — surfaced to the caller as a normal
      // failed operation rather than a special case; ErrorParser already
      // turns this into an AuthFailure.
      throw const InvalidSessionException();
    }

    final json =
        await _apiService.refreshToken({'refreshToken': storedRefreshToken});
    final envelope = AuthApiEnvelope.fromJson(json);
    _throwIfEnvelopeFailed(envelope);
    await _persistSession(envelope.dataAsMap);
  }

  /// The backend can respond with HTTP 200 while the envelope itself
  /// reports a business-logic failure — confirmed live against the
  /// running Auth service: a Sign Up rejected for an Identity
  /// password-policy violation came back as HTTP 200 with
  /// `{"status":false,"code":500,"errors":["...PasswordRequiresNonAlpha
  /// numeric..."]}`. Dio only throws on a non-2xx transport status, so
  /// without this check that response was silently treated as a
  /// success — the UI showed "account created" and navigated to Login
  /// for an account that was never created.
  ///
  /// `envelope.code` is itself typed as `HttpStatusCode` in the
  /// backend's own contract (every `*ApiResponse` schema in
  /// `docker/auth-swagger.json`), so a failed envelope is routed through
  /// the exact same [ApiException] → [ErrorParser] status-code mapping
  /// as a real HTTP error status — one mapping table, not a second
  /// bespoke one.
  void _throwIfEnvelopeFailed(AuthApiEnvelope envelope) {
    if (envelope.status) return;
    final serverErrors = envelope.errors;
    final serverMessage = envelope.message;
    final message = (serverErrors != null && serverErrors.isNotEmpty)
        ? serverErrors.first
        : (serverMessage != null && serverMessage.isNotEmpty)
            ? serverMessage
            : 'Request failed.';
    throw ApiException(statusCode: envelope.code ?? 400, message: message);
  }

  /// Writes accessToken/refreshToken/expiry to secure storage — the
  /// single place this happens, so every entry point (login today,
  /// refresh tomorrow) keeps the session store consistent.
  Future<void> _persistSession(Map<String, dynamic> authResponse) async {
    final accessToken = authResponse['accessToken'] as String? ?? '';
    final refreshToken = authResponse['refreshToken'] as String?;
    final expiresInSeconds = authResponse['expiresIn'] as int? ?? 0;

    await _secureStorage.saveToken(accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _secureStorage.saveRefreshToken(refreshToken);
    }
    if (expiresInSeconds > 0) {
      await _secureStorage.saveTokenExpiry(
        DateTime.now().toUtc().add(Duration(seconds: expiresInSeconds)),
      );
    }
  }

  Future<UserEntity> _persistSessionAndBuildUser(
    Map<String, dynamic> authResponse, {
    required String fallbackEmail,
  }) async {
    await _persistSession(authResponse);

    final accessToken = authResponse['accessToken'] as String? ?? '';
    final claims = JwtPayloadDecoder.decode(accessToken) ?? const {};

    // The Auth service's login response carries only accessToken,
    // refreshToken, expiresIn, role, driverStatus — no name/email — so
    // the display name/id are read from the JWT's own claims (issued by
    // the same backend, not fabricated) rather than left blank or faked.
    final fullNameClaim = claims['unique_name'] as String?;
    final (firstName, lastName) = _splitFullName(fullNameClaim);
    final userId = claims['nameid'] as String? ?? '';
    final claimEmail = claims['email'] as String? ?? fallbackEmail;

    return UserEntity(
      id: userId,
      firstName: firstName,
      lastName: lastName,
      email: claimEmail,
    );
  }

  /// Splits a single `fullName` claim into (firstName, lastName) at the
  /// first space — the backend only stores/returns a single name field,
  /// while [UserEntity] (shared with the rest of the app) models
  /// first/last separately. Not lossless for multi-part surnames, but
  /// there is no better signal available from the backend today.
  (String, String) _splitFullName(String? fullName) {
    final trimmed = fullName?.trim() ?? '';
    if (trimmed.isEmpty) return ('', '');
    final spaceIndex = trimmed.indexOf(' ');
    if (spaceIndex == -1) return (trimmed, '');
    return (
      trimmed.substring(0, spaceIndex),
      trimmed.substring(spaceIndex + 1).trim(),
    );
  }
}
