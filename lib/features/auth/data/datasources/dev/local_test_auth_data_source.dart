import 'package:flutter/foundation.dart';

import '../../../../../core/domain/entities/user_entity.dart';
import '../auth_remote_data_source.dart';

/// DEVELOPMENT/TESTING ONLY — never wired in a release build (see `injectable_injector.config.dart`'s
/// `kDebugMode` gate, which also lets the release compiler tree-shake this whole class out).
///
/// A [AuthRemoteDataSource] decorator that intercepts `login()` for exactly one hardcoded local
/// account ([testEmail]/[testPassword]) so the app — and anything downstream of a signed-in session,
/// like Home — can be exercised before the real backend is reachable. Every other `login()` call,
/// and every other method on this interface, is forwarded untouched to the wrapped real
/// [AuthRemoteDataSource]: nothing here ever reaches the network for the test account, and the real
/// API path is never modified, weakened, or bypassed for anyone using real credentials.
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
