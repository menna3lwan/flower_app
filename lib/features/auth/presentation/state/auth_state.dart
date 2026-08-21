import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/user_entity.dart';
import 'package:customer_app/core/error/failures.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthLoginSuccess extends AuthState {
  const AuthLoginSuccess(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

final class AuthSignUpSuccess extends AuthState {
  const AuthSignUpSuccess();
}

final class AuthPasswordResetEmailSent extends AuthState {
  const AuthPasswordResetEmailSent(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

final class AuthCodeVerified extends AuthState {
  const AuthCodeVerified({required this.email, required this.resetToken});

  final String email;

  /// Must be forwarded to [ResetPasswordRequested] — the backend
  /// requires it in place of email/code on the Reset Password call.
  final String resetToken;

  @override
  List<Object?> get props => [email, resetToken];
}

final class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}

final class AuthFailed extends AuthState {
  const AuthFailed(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
