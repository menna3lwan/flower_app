import '../error/failures.dart';

/// Explicit success/failure wrapper returned by every repository method.
///
/// Modeling this as a sealed class (rather than throwing) forces callers
/// (use cases, cubits) to handle both branches via [when]/[fold] — there
/// is no code path where a failure can be silently ignored.
sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(Failure failure) = ResultFailure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;

  /// Pattern-match both branches and collapse them into a single value.
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  ) {
    final self = this;
    return switch (self) {
      Success<T>() => onSuccess(self.data),
      ResultFailure<T>() => onFailure(self.failure),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.failure);

  final Failure failure;
}
