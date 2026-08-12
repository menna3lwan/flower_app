import 'package:equatable/equatable.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

final class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

final class ForgotPasswordSubmitting extends ForgotPasswordState {
  const ForgotPasswordSubmitting();
}

final class ForgotPasswordEmailSent extends ForgotPasswordState {
  const ForgotPasswordEmailSent();
}

final class ForgotPasswordFailed extends ForgotPasswordState {
  const ForgotPasswordFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
