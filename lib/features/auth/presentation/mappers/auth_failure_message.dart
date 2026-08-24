import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/localization/app_strings.dart';
extension AuthFailureMessage on Failure {
  /// Login screen: email/password submit.
  String get loginMessage => switch (this) {
        InvalidCredentialsFailure() ||
        AuthFailure() =>
          AppStrings.loginInvalidCredentials,
        NetworkFailure() => AppStrings.noInternetConnection,
        RateLimitedFailure() => AppStrings.tooManyAttempts,
        ValidationFailure(:final message) when message.trim().isNotEmpty =>
          message,
        ServerFailure() ||
        ValidationFailure() ||
        UnexpectedFailure() ||
        NotFoundFailure() ||
        ConflictFailure() ||
        InvalidVerificationCodeFailure() =>
          AppStrings.somethingWentWrong,
      };

  /// Sign Up screen: create-account submit.
  String get signUpMessage => switch (this) {
        ConflictFailure() => AppStrings.emailAlreadyRegistered,
        NetworkFailure() => AppStrings.noInternetConnection,
        RateLimitedFailure() => AppStrings.tooManyAttempts,
        ValidationFailure(:final message) when message.trim().isNotEmpty =>
          message,
        AuthFailure() ||
        ServerFailure() ||
        ValidationFailure() ||
        UnexpectedFailure() ||
        NotFoundFailure() ||
        InvalidVerificationCodeFailure() ||
        InvalidCredentialsFailure() =>
          AppStrings.somethingWentWrong,
      };

  /// Forgot Password screen: "send me a code" submit.
  String get forgotPasswordMessage => switch (this) {
        NotFoundFailure() => AppStrings.emailNotFound,
        NetworkFailure() => AppStrings.noInternetConnection,
        RateLimitedFailure() => AppStrings.tooManyAttempts,
        ValidationFailure(:final message) when message.trim().isNotEmpty =>
          message,
        AuthFailure() ||
        ServerFailure() ||
        ValidationFailure() ||
        UnexpectedFailure() ||
        ConflictFailure() ||
        InvalidVerificationCodeFailure() ||
        InvalidCredentialsFailure() =>
          AppStrings.somethingWentWrong,
      };

  /// OTP screen's "resend" failure is tracked separately via `forgotPasswordState`, never read through this getter.
  String get verifyOtpMessage => switch (this) {
        InvalidVerificationCodeFailure() => AppStrings.invalidVerificationCode,
        // The backend's 404 for verify-otp reads identically to "wrong or expired code" from the user's point of view.
        NotFoundFailure() => AppStrings.invalidVerificationCode,
        NetworkFailure() => AppStrings.noInternetConnection,
        RateLimitedFailure() => AppStrings.tooManyAttempts,
        ValidationFailure(:final message) when message.trim().isNotEmpty =>
          message,
        AuthFailure() ||
        ServerFailure() ||
        ValidationFailure() ||
        UnexpectedFailure() ||
        ConflictFailure() ||
        InvalidCredentialsFailure() =>
          AppStrings.somethingWentWrong,
      };

  /// Reset Password screen: submitting the new password with the reset token carried over from OTP verification.
  String get resetPasswordMessage => switch (this) {
        // The reset-password endpoint's 404/401/403 means the reset token is unknown/used/expired — never "email not found".
        NotFoundFailure() => AppStrings.resetLinkExpired,
        AuthFailure() => AppStrings.resetLinkExpired,
        NetworkFailure() => AppStrings.noInternetConnection,
        RateLimitedFailure() => AppStrings.tooManyAttempts,
        ValidationFailure(:final message) when message.trim().isNotEmpty =>
          message,
        ServerFailure() ||
        ValidationFailure() ||
        UnexpectedFailure() ||
        ConflictFailure() ||
        InvalidVerificationCodeFailure() ||
        InvalidCredentialsFailure() =>
          AppStrings.somethingWentWrong,
      };
}
