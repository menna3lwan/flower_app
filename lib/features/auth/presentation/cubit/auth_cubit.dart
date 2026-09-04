import 'package:customer_app/core/base/base_cubit.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/continue_as_guest_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../intent/auth_intent.dart';
import '../state/auth_state.dart';

/// The single Cubit for the whole Auth module — every intent flows through [onIntent], which only calls a use case and maps the [Result] into [AuthState].
@injectable
class AuthCubit extends BaseCubit<AuthState> {
  AuthCubit(
    this._loginUseCase,
    this._continueAsGuestUseCase,
    this._signUpUseCase,
    this._forgotPasswordUseCase,
    this._verifyOtpUseCase,
    this._resetPasswordUseCase,
  ) : super(const AuthState());

  final LoginUseCase _loginUseCase;
  final ContinueAsGuestUseCase _continueAsGuestUseCase;
  final SignUpUseCase _signUpUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  Future<void> onIntent(AuthIntent intent) => switch (intent) {
        LoginRequested() => _login(intent),
        GuestLoginRequested() => _continueAsGuest(),
        SignUpRequested() => _signUp(intent),
        ForgotPasswordRequested() => _sendPasswordResetEmail(intent),
        VerifyCodeRequested() => _verifyCode(intent),
        ResetPasswordRequested() => _resetPassword(intent),
      };

  Future<void> _login(LoginRequested intent) async {
    safeEmit(state.copyWith(loginState: state.loginState.loading()));
    final result =
        await _loginUseCase(email: intent.email, password: intent.password);
    safeEmit(state.copyWith(
      loginState: result.fold(
        (failure) => state.loginState.failed(failure),
        (user) => state.loginState.success(user),
      ),
    ));
  }

  Future<void> _continueAsGuest() async {
    safeEmit(state.copyWith(loginState: state.loginState.loading()));
    final result = await _continueAsGuestUseCase();
    safeEmit(state.copyWith(
      loginState: result.fold(
        (failure) => state.loginState.failed(failure),
        (user) => state.loginState.success(user),
      ),
    ));
  }

  Future<void> _signUp(SignUpRequested intent) async {
    safeEmit(state.copyWith(signUpState: state.signUpState.loading()));
    final result = await _signUpUseCase(
      firstName: intent.firstName,
      lastName: intent.lastName,
      email: intent.email,
      password: intent.password,
      confirmPassword: intent.confirmPassword,
      phoneNumber: intent.phoneNumber,
      gender: intent.gender,
    );
    safeEmit(state.copyWith(
      // The new UserEntity is discarded — Sign Up doesn't start a session; the flow is Sign Up -> Success -> Login.
      signUpState: result.fold(
        (failure) => state.signUpState.failed(failure),
        (_) => state.signUpState.success(null),
      ),
    ));
  }

  Future<void> _sendPasswordResetEmail(ForgotPasswordRequested intent) async {
    safeEmit(state.copyWith(
      forgotPasswordState: state.forgotPasswordState.loading(),
    ));
    final result = await _forgotPasswordUseCase(intent.email);
    safeEmit(state.copyWith(
      forgotPasswordState: result.fold(
        (failure) => state.forgotPasswordState.failed(failure),
        (_) => state.forgotPasswordState.success(intent.email),
      ),
    ));
  }

  Future<void> _verifyCode(VerifyCodeRequested intent) async {
    safeEmit(state.copyWith(verifyOtpState: state.verifyOtpState.loading()));
    final result =
        await _verifyOtpUseCase(email: intent.email, code: intent.code);
    safeEmit(state.copyWith(
      verifyOtpState: result.fold(
        (failure) => state.verifyOtpState.failed(failure),
        (resetToken) => state.verifyOtpState.success(resetToken),
      ),
    ));
  }

  Future<void> _resetPassword(ResetPasswordRequested intent) async {
    safeEmit(state.copyWith(
      resetPasswordState: state.resetPasswordState.loading(),
    ));
    final result = await _resetPasswordUseCase(
      resetToken: intent.resetToken,
      newPassword: intent.newPassword,
      confirmNewPassword: intent.confirmNewPassword,
    );
    safeEmit(state.copyWith(
      resetPasswordState: result.fold(
        (failure) => state.resetPasswordState.failed(failure),
        (_) => state.resetPasswordState.success(null),
      ),
    ));
  }
}
