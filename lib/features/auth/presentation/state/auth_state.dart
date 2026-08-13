import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/user_entity.dart';

/// Every state the unified Auth flow (Login, Sign Up, Forgot Password,
/// Verification, Reset Password) can be in — this is the "Model" the
/// five Views render from. Only `AuthCubit` moves between these; a View
/// just reacts.
///
/// Login/Sign Up/guest-login all resolve to [AuthLoginSuccess] — from
/// the View's perspective they mean the same thing (a [UserEntity] now
/// exists, proceed to Home), so they don't need separate states. Sign
/// Up gets its own [AuthSignUpSuccess] instead of also folding into
/// [AuthLoginSuccess] only because `SignUpView` needs to know a new
/// account was actually created, not just that some session started.
/// Forgot Password's success carries no user (no one is authenticated
/// yet), so it's a distinct shape, not an overload of the others.
/// [AuthCodeVerified] and [AuthPasswordResetSuccess] are likewise
/// distinct from each other and from the rest — each drives a different
/// navigation target (Verification → Login, Reset Password → Login) and
/// carries no payload the View needs.
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
  const AuthSignUpSuccess(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

final class AuthPasswordResetEmailSent extends AuthState {
  const AuthPasswordResetEmailSent(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

final class AuthCodeVerified extends AuthState {
  const AuthCodeVerified();
}

final class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}

final class AuthFailed extends AuthState {
  const AuthFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
