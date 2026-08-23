import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/localization/app_strings.dart';

/// Maps a [Failure] to the copy shown on-screen — one getter per Auth
/// screen instead of a single global mapping.
///
/// Why per-screen instead of one shared `localizedMessage`: the *same*
/// [Failure] subtype means something different depending on which action
/// produced it. A [NotFoundFailure] on Forgot Password means "no account
/// with that email"; the same [NotFoundFailure] on Reset Password (the
/// backend's own 404 for an unknown/expired reset token, per
/// `docker/auth-swagger.json`) means "this reset link expired" — showing
/// the Forgot-Password wording there would be actively confusing. Each
/// getter below is a deliberate, screen-specific reading of what a given
/// failure means in that one context.
///
/// [ValidationFailure] is the one case that *does* pass the backend's own
/// message straight through: it carries the API's own field-validation
/// text (already localized server-side via the `Accept-Language` header —
/// see `AcceptLanguageInterceptor`), which is a legitimate, human-authored
/// message rather than framework/HTTP internals. Everything else
/// (`ServerFailure`, `UnexpectedFailure`, a bare `AuthFailure`) collapses
/// to a single safe, friendly fallback so raw exception text can never
/// reach the user.
///
/// [InvalidCredentialsFailure] is only ever produced by Login (see
/// `AuthRepositoryImpl`/`ErrorParser` — nothing on Sign Up, Forgot
/// Password, Verify OTP, or Reset Password can raise it), but `Failure`
/// is one shared sealed hierarchy, so every switch over it must stay
/// exhaustive regardless of which cases are actually reachable on a given
/// screen. It is intentionally folded into each of those four screens'
/// generic fallback rather than left unhandled — an IDE "quick fix" once
/// filled the gap with `throw UnimplementedError()`, which would have
/// crashed the app the first time the sealed-class checker's edge case
/// was hit; a safe fallback message is the correct unreachable-in-practice
/// default, never a throw.
extension AuthFailureMessage on Failure {
  /// Login screen: email/password submit.
  String get loginMessage => switch (this) {
        InvalidCredentialsFailure() => AppStrings.loginInvalidCredentials,
        NetworkFailure() => AppStrings.noInternetConnection,
        RateLimitedFailure() => AppStrings.tooManyAttempts,
        ValidationFailure(:final message) when message.trim().isNotEmpty =>
          message,
        AuthFailure() ||
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

  /// OTP / Verification screen: submitting the code. (Its "resend"
  /// action reuses the same [AuthCubit] instance but is tracked as its
  /// own `forgotPasswordState` field on `AuthState`, with its own
  /// `forgotPasswordMessage` getter below — so a resend failure is never
  /// read through this getter.)
  String get verifyOtpMessage => switch (this) {
        InvalidVerificationCodeFailure() => AppStrings.invalidVerificationCode,
        // The backend's own 404 for verify-otp means the code/session
        // wasn't found — from the user's point of view that reads
        // identically to "wrong or expired code".
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

  /// Reset Password screen: submitting the new password with the reset
  /// token carried over from OTP verification.
  String get resetPasswordMessage => switch (this) {
        // The reset-password endpoint's own 404/401/403 means the reset
        // token is unknown, already used, or expired — never "email not
        // found" (there is no email field on this screen at all).
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
