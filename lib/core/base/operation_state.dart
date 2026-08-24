import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Where a single async operation currently stands.
enum OperationStatus { idle, loading, success, failure }

/// One operation's status/data/failure, used as a field per operation inside a feature's single state class (see `AuthState`).
class OperationState<T> extends Equatable {
  const OperationState({
    this.status = OperationStatus.idle,
    this.data,
    this.failure,
  });

  final OperationStatus status;
  final T? data;
  final Failure? failure;

  bool get isIdle => status == OperationStatus.idle;
  bool get isLoading => status == OperationStatus.loading;
  bool get isSuccess => status == OperationStatus.success;
  bool get isFailure => status == OperationStatus.failure;

  /// Fresh in-flight state; drops previous data/failure so a stale error can't linger into a new attempt.
  OperationState<T> loading() =>
      OperationState<T>(status: OperationStatus.loading);

  OperationState<T> success(T data) => OperationState<T>(
        status: OperationStatus.success,
        data: data,
      );

  OperationState<T> failed(Failure failure) => OperationState<T>(
        status: OperationStatus.failure,
        failure: failure,
      );

  @override
  List<Object?> get props => [status, data, failure];
}
