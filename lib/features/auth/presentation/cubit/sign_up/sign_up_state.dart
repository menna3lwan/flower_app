import 'package:equatable/equatable.dart';

import '../../../../../core/domain/entities/user_entity.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

final class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

final class SignUpSubmitting extends SignUpState {
  const SignUpSubmitting();
}

final class SignUpSuccess extends SignUpState {
  const SignUpSuccess(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

final class SignUpFailed extends SignUpState {
  const SignUpFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
