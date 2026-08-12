import 'package:equatable/equatable.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

final class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial();
}

final class ResetPasswordSubmitting extends ResetPasswordState {
  const ResetPasswordSubmitting();
}

final class ResetPasswordSuccess extends ResetPasswordState {
  const ResetPasswordSuccess();
}

final class ResetPasswordFailed extends ResetPasswordState {
  const ResetPasswordFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
