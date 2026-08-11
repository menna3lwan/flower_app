import 'package:equatable/equatable.dart';

/// Base type for every recoverable failure that can cross a repository
/// boundary into the presentation layer.
///
/// Cubits should never see a raw [Exception] — the data layer is
/// responsible for catching exceptions and mapping them to a concrete
/// [Failure] subtype so the UI can react to a closed, well-known set of
/// error cases instead of an open-ended throwable.
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
  const ServerFailure([super.message = 'Something went wrong. Please try again.']);
}

/// Input supplied by the user failed validation before reaching a use case.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Requested entity does not exist (e.g. product id, saved address id).
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'The requested item was not found.']);
}

/// Authentication/authorization failed (bad credentials, expired session).
final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

/// Fallback for anything that doesn't map to a more specific failure.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}
