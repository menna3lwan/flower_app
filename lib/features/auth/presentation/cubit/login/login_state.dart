import 'package:equatable/equatable.dart';

import '../../../../../core/domain/entities/user_entity.dart';

/// Every state the Login screen can be in, modeled as a sealed hierarchy
/// (MVI: this *is* the "Model" the view renders from). The Cubit is the
/// only thing that can move between these — `LoginView` just reacts.
sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginSubmitting extends LoginState {
  const LoginSubmitting();
}

final class LoginSuccess extends LoginState {
  const LoginSuccess(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

final class LoginFailed extends LoginState {
  const LoginFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
