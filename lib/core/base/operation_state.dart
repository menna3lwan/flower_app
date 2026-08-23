import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Where a single async operation currently stands.
enum OperationStatus { idle, loading, success, failure }

/// One operation's status, its success payload (if any), and its
/// [Failure] (if any) — reused as a field type inside a feature's single
/// state class, one field per operation that state needs to track, e.g.:
///
/// ```dart
/// class AuthState extends Equatable {
///   const AuthState({
///     this.loginState = const OperationState<UserEntity>(),
///     this.signUpState = const OperationState<Object?>(),
///     ...
///   });
///
///   final OperationState<UserEntity> loginState;
///   final OperationState<Object?> signUpState;
///   ...
/// }
/// ```
///
/// This is the base/core half of the "one single state per feature"
/// rule: a feature Cubit still emits exactly one state object, but that
/// object can represent several independent, concurrently-tracked
/// operations (Login, Sign Up, Forgot Password, ...) without those
/// operations needing separate state *classes* — see `AuthState` for the
/// concrete example this was built for.
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

  /// A fresh in-flight state — deliberately drops any previous [data]/
  /// [failure] rather than carrying them forward, so a stale error from
  /// a prior failed attempt can't linger once a new one starts.
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
