import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// The local/remote data source is unreachable or timed out.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
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

/// The request conflicts with existing state (HTTP 409) — e.g. Sign Up
/// with an email that is already registered.
final class ConflictFailure extends Failure {
  const ConflictFailure([super.message = 'This already exists.']);
}

/// Authentication/authorization failed (bad credentials, expired session).
final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
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
