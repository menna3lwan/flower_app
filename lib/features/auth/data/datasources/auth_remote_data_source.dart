import 'package:customer_app/core/error/exceptions.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/jwt_payload_decoder.dart';
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

/// Talks to the real FlowersApp.Auth backend through the API Gateway.
///
/// Every path/request/response shape here is taken from the live
/// backend's own Swagger document (read directly off the running
/// `flowersapp-auth` container with `ASPNETCORE_ENVIRONMENT=Development`,
/// saved at `docker/auth-swagger.json`) and cross-checked with real curl
/// calls through the Gateway — nothing here is guessed. See
/// `core/network/api_endpoints.dart` for the confirmed path list and
/// `docs/BACKEND_INTEGRATION_TODO.md` for the one open ambiguity (the
/// Gender 1/2 wire mapping).
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient, this._secureStorage);

  final ApiClient _apiClient;
  final SecureStorageService _secureStorage;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final json = await _apiClient.post(
      ApiEndpoints.userLogin,
      body: {'email': email, 'password': password},
    );
    final envelope = AuthApiEnvelope.fromJson(json);
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
    final json = await _apiClient.post(
      ApiEndpoints.register,
      body: {
        'fullName': '$firstName $lastName'.trim(),
        'email': email,
        'phoneNumber': phoneNumber,
        'gender': gender.apiValue,
        'password': password,
        'confirmPassword': confirmPassword,
      },
    );
    final envelope = AuthApiEnvelope.fromJson(json);

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
    await _apiClient.post(ApiEndpoints.forgotPassword, body: {'email': email});
  }

  @override
  Future<String> verifyCode({
    required String email,
    required String code,
  }) async {
    final json = await _apiClient.post(
      ApiEndpoints.verifyOtp,
      body: {'email': email, 'otp': code},
    );
    final envelope = AuthApiEnvelope.fromJson(json);
    return envelope.dataAsMap['resetToken'] as String? ?? '';
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    await _apiClient.post(
      ApiEndpoints.resetPassword,
      body: {
        'resetToken': resetToken,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      },
    );
  }

  @override
  Future<void> refreshSession() async {
    final storedRefreshToken = await _secureStorage.readRefreshToken();
    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      // Nothing to refresh with — surfaced to the caller as a normal
      // failed operation rather than a special case; the repository's
      // exception mapping already turns this into an AuthFailure.
      throw const InvalidSessionException();
    }

    final json = await _apiClient.post(
      ApiEndpoints.refreshToken,
      body: {'refreshToken': storedRefreshToken},
    );
    final envelope = AuthApiEnvelope.fromJson(json);
    await _persistSession(envelope.dataAsMap);
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
