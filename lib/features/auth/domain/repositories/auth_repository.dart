import '../../../../core/domain/entities/user_entity.dart';
import 'package:customer_app/core/result/result.dart';

abstract interface class AuthRepository {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required Gender gender,
  });

  Future<Result<UserEntity>> continueAsGuest();

  Future<Result<void>> sendPasswordResetEmail(String email);

  /// Confirms the code sent by [sendPasswordResetEmail] to `email`.
  ///
  /// Returns the one-time `resetToken` the backend issues on a
  /// successful verification (`VerifyOtpResponse.resetToken`, confirmed
  /// against the live Auth service) — [resetPassword] requires it in
  /// place of the email/code, so it must be threaded through the
  /// Verify-OTP -> Reset-Password navigation instead of being discarded.
  Future<Result<String>> verifyCode({
    required String email,
    required String code,
  });

  Future<Result<void>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  });

  /// Exchanges the stored refresh token for a new access/refresh token
  /// pair and persists them, without requiring the user to log in again.
  /// Confirmed supported by the backend (`POST /Auth/api/v1/refresh-token`
  /// -> `AuthResponseApiResponse`) — not wired to an automatic 401-retry
  /// interceptor yet (see docs/BACKEND_INTEGRATION_TODO.md), but callable
  /// today for a deliberate "restore session" use on app start.
  Future<Result<void>> refreshSession();
}
