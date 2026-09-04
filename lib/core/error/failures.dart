import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// The local/remote data source is unreachable or timed out. `base` (not `final`) so [TimeoutFailure] can specialize it below while every existing `NetworkFailure()` switch pattern keeps matching both.
base class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// The request reached the network stack but exceeded its time budget (connect/send/receive) — distinct from [NetworkFailure]'s plain "no connectivity" case, still routed through the same UI copy today.
final class TimeoutFailure extends NetworkFailure {
  const TimeoutFailure([super.message = 'The request timed out. Please try again.']);
}

/// The data source responded but with an error payload/status.
final class ServerFailure extends Failure {
  const ServerFailure(
      [super.message = 'Something went wrong. Please try again.']);
}

/// Input supplied by the user failed validation before reaching a use case.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Requested entity does not exist (e.g. product id, saved address id).
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'The requested item was not found.']);
}

/// Request conflicts with existing state (HTTP 409) — e.g. Sign Up with an already-registered email.
final class ConflictFailure extends Failure {
  const ConflictFailure([super.message = 'This already exists.']);
}

/// Authentication/authorization failed (bad credentials, expired session). `base` (not `final`) so [UnauthorizedFailure]/[ForbiddenFailure] can specialize it below while every existing `AuthFailure()` switch pattern keeps matching both.
base class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

/// HTTP 401 — the request had no/invalid/expired credentials.
final class UnauthorizedFailure extends AuthFailure {
  const UnauthorizedFailure([super.message = 'Your session has expired. Please log in again.']);
}

/// HTTP 403 — credentials were valid but don't permit this action.
final class ForbiddenFailure extends AuthFailure {
  const ForbiddenFailure([super.message = "You don't have permission to perform this action."]);
}

/// The email/password pair supplied at Login was rejected.
final class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure() : super('Invalid email or password.');
}

/// The OTP entered on the Verification screen was wrong or has expired.
final class InvalidVerificationCodeFailure extends Failure {
  const InvalidVerificationCodeFailure()
      : super('Invalid or expired verification code.');
}

/// Fallback for anything that doesn't map to a more specific failure.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}

/// Backend rejected the request for being too frequent (HTTP 429) — confirmed on Login/Driver Login/Forgot Password.
final class RateLimitedFailure extends Failure {
  const RateLimitedFailure([super.message = 'Too many attempts.']);
}
