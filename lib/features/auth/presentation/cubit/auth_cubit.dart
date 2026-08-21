import 'package:customer_app/core/base/base_cubit.dart';

import '../../domain/repositories/auth_repository.dart';
import '../intent/auth_intent.dart';
import '../state/auth_state.dart';

class AuthCubit extends BaseCubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthInitial());

  final AuthRepository _authRepository;

  Future<void> onIntent(AuthIntent intent) => switch (intent) {
        LoginRequested() => _login(intent),
        GuestLoginRequested() => _continueAsGuest(),
        SignUpRequested() => _signUp(intent),
        ForgotPasswordRequested() => _sendPasswordResetEmail(intent),
        VerifyCodeRequested() => _verifyCode(intent),
        ResetPasswordRequested() => _resetPassword(intent),
      };

  Future<void> _login(LoginRequested intent) async {
    safeEmit(const AuthLoading());
    final result = await _authRepository.login(
      email: intent.email,
      password: intent.password,
    );
    result.fold(
      (failure) => safeEmit(AuthFailed(failure)),
      (user) => safeEmit(AuthLoginSuccess(user)),
    );
  }

  Future<void> _continueAsGuest() async {
    safeEmit(const AuthLoading());
    final result = await _authRepository.continueAsGuest();
    result.fold(
      (failure) => safeEmit(AuthFailed(failure)),
      (user) => safeEmit(AuthLoginSuccess(user)),
    );
  }

  Future<void> _signUp(SignUpRequested intent) async {
    safeEmit(const AuthLoading());
    final result = await _authRepository.signUp(
      firstName: intent.firstName,
      lastName: intent.lastName,
      email: intent.email,
      password: intent.password,
      confirmPassword: intent.confirmPassword,
      phoneNumber: intent.phoneNumber,
      gender: intent.gender,
    );
    result.fold(
      (failure) => safeEmit(AuthFailed(failure)),
      (_) => safeEmit(const AuthSignUpSuccess()),
    );
  }

  Future<void> _sendPasswordResetEmail(ForgotPasswordRequested intent) async {
    safeEmit(const AuthLoading());
    final result = await _authRepository.sendPasswordResetEmail(intent.email);
    result.fold(
      (failure) => safeEmit(AuthFailed(failure)),
      (_) => safeEmit(AuthPasswordResetEmailSent(intent.email)),
    );
  }

  Future<void> _verifyCode(VerifyCodeRequested intent) async {
    safeEmit(const AuthLoading());
    final result = await _authRepository.verifyCode(
      email: intent.email,
      code: intent.code,
    );
    result.fold(
      (failure) => safeEmit(AuthFailed(failure)),
      (resetToken) => safeEmit(
        AuthCodeVerified(email: intent.email, resetToken: resetToken),
      ),
    );
  }

  Future<void> _resetPassword(ResetPasswordRequested intent) async {
    safeEmit(const AuthLoading());
    final result = await _authRepository.resetPassword(
      resetToken: intent.resetToken,
      newPassword: intent.newPassword,
      confirmNewPassword: intent.confirmNewPassword,
    );
    result.fold(
      (failure) => safeEmit(AuthFailed(failure)),
      (_) => safeEmit(const AuthPasswordResetSuccess()),
    );
  }
}
