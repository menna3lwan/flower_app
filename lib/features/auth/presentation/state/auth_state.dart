import 'package:equatable/equatable.dart';

import '../../../../core/base/operation_state.dart';
import '../../../../core/domain/entities/user_entity.dart';

/// The Auth feature's one and only state class.
///
/// Previously this was a sealed hierarchy with one class per moment
/// (`AuthInitial`, `AuthLoading`, `AuthLoginSuccess`, `AuthSignUpSuccess`,
/// `AuthPasswordResetEmailSent`, `AuthCodeVerified`,
/// `AuthPasswordResetSuccess`, `AuthFailed`) — which meant a single
/// shared [AuthCubit] instance could only ever represent *one*
/// in-flight/most-recent operation at a time, even though the OTP screen
/// alone drives two independent ones (verifying the code, and resending
/// it). [AuthState] instead holds one [OperationState] field per
/// operation, so each screen reads only the field(s) it cares about and
/// nothing is lost when two operations are relevant on the same screen.
///
/// Login and "continue as guest" intentionally share [loginState]: both
/// are just different ways of arriving at "the user is now signed in",
/// not two separate concepts worth their own field.
class AuthState extends Equatable {
  const AuthState({
    this.loginState = const OperationState<UserEntity>(),
    this.signUpState = const OperationState<Object?>(),
    this.forgotPasswordState = const OperationState<String>(),
    this.verifyOtpState = const OperationState<String>(),
    this.resetPasswordState = const OperationState<Object?>(),
  });

  /// Covers both [LoginRequested] and [GuestLoginRequested] — success
  /// data is the signed-in (or guest) [UserEntity].
  final OperationState<UserEntity> loginState;

  /// No success payload beyond "it worked" — see `AuthCubit._signUp`.
  final OperationState<Object?> signUpState;

  /// Success data is the email the code was just sent to — the OTP
  /// screen needs it for the "resend" action and, from Forgot Password,
  /// for navigating to the OTP screen.
  final OperationState<String> forgotPasswordState;

  /// Success data is the one-time `resetToken` [ResetPasswordUseCase]
  /// requires — see `AuthRepository.verifyCode`.
  final OperationState<String> verifyOtpState;

  final OperationState<Object?> resetPasswordState;

  AuthState copyWith({
    OperationState<UserEntity>? loginState,
    OperationState<Object?>? signUpState,
    OperationState<String>? forgotPasswordState,
    OperationState<String>? verifyOtpState,
    OperationState<Object?>? resetPasswordState,
  }) {
    return AuthState(
      loginState: loginState ?? this.loginState,
      signUpState: signUpState ?? this.signUpState,
      forgotPasswordState: forgotPasswordState ?? this.forgotPasswordState,
      verifyOtpState: verifyOtpState ?? this.verifyOtpState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
    );
  }

  @override
  List<Object?> get props => [
        loginState,
        signUpState,
        forgotPasswordState,
        verifyOtpState,
        resetPasswordState,
      ];
}
