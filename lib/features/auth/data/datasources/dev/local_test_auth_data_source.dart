import 'package:flutter/foundation.dart';

import '../../../../../core/domain/entities/user_entity.dart';
import '../auth_remote_data_source.dart';

/// Debug-only [AuthRemoteDataSource] decorator that intercepts one hardcoded local login.
class LocalTestAuthDataSource implements AuthRemoteDataSource {
  const LocalTestAuthDataSource(this._realDataSource);

  final AuthRemoteDataSource _realDataSource;

  /// Local-only, non-production placeholder — not a real account on any backend.
  static const testEmail = 'test.local@flowery.dev';

  /// Local-only, non-production placeholder — not a real account on any backend.
  static const testPassword = 'LocalTest123!';

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().toLowerCase() == testEmail && password == testPassword) {
      debugPrint(
        '[LocalTestAuthDataSource] DEV-ONLY local login used — no request sent to the real Auth API.',
      );
      return const UserEntity(
        id: 'local-test-user',
        firstName: 'Local',
        lastName: 'Tester',
        email: testEmail,
      );
    }
    return _realDataSource.login(email: email, password: password);
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
  }) {
    return _realDataSource.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
      gender: gender,
    );
  }

  @override
  Future<UserEntity> continueAsGuest() => _realDataSource.continueAsGuest();

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      _realDataSource.sendPasswordResetEmail(email);

  @override
  Future<String> verifyCode({required String email, required String code}) =>
      _realDataSource.verifyCode(email: email, code: code);

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  }) {
    return _realDataSource.resetPassword(
      resetToken: resetToken,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
  }

  @override
  Future<void> refreshSession() => _realDataSource.refreshSession();
}
