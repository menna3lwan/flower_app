import 'package:injectable/injectable.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/jwt_payload_decoder.dart';
import '../../api/auth_api_service.dart';
import '../models/auth_api_envelope.dart';
import 'auth_remote_data_source.dart';

/// Talks to the real Auth backend via Retrofit; every path/shape is confirmed against the live Swagger + curl, and this class only ever throws — never returns a Result itself. The production DI registration (`core/di/injectable_injector.config.dart`) is the only place [AuthRemoteDataSource] is bound, so this is the sole implementation the app runs against.
@LazySingleton(as: AuthRemoteDataSource)
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

    // Register only returns the new user's id, no token/profile — the rest of the entity is built from what the caller submitted.
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
      // Nothing to refresh with — surfaced as a normal failed operation; ErrorParser already turns this into an AuthFailure.
      throw const InvalidSessionException();
    }

    final json =
        await _apiService.refreshToken({'refreshToken': storedRefreshToken});
    final envelope = AuthApiEnvelope.fromJson(json);
    _throwIfEnvelopeFailed(envelope);
    await _persistSession(envelope.dataAsMap);
  }

  /// The backend can return HTTP 200 with a business-logic failure in the envelope — confirmed live, so this check exists to avoid silently treating that as success.
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

  /// Single place accessToken/refreshToken/expiry are written to secure storage, so every entry point stays consistent.
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

    // Login's response carries no name/email, so the display name/id are read from the JWT's own claims instead.
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

  /// Splits a single `fullName` claim at the first space since the backend has no separate first/last name fields; not lossless for multi-part surnames.
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
