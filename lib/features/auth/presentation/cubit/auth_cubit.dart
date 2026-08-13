import 'package:customer_app/core/base/base_cubit.dart';

import '../../domain/repositories/auth_repository.dart';
import '../intent/auth_intent.dart';
import '../state/auth_state.dart';

/// Single Cubit for the whole Auth flow (Login, Sign Up, Forgot
/// Password) — orchestration only. It calls [AuthRepository] and maps
/// the `Result` it gets back onto an [AuthState]; no validation or
/// business rule lives here (field-level validation stays in
/// `Validators` + `TextFormField`, credential/account rules stay in the
/// repository/data source).
///
/// One Cubit instead of three (`LoginCubit`/`SignUpCubit`/
/// `ForgotPasswordCubit`) because all three screens are steps of the
/// same Auth journey against the same repository — splitting them
/// bought no isolation, just three near-identical
/// emit-loading/call-repository/fold-result blocks. [onIntent] is the
/// single entry point a View calls; which private handler runs is
/// decided by pattern-matching the sealed [AuthIntent] passed in.
class AuthCubit extends BaseCubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthInitial());

  final AuthRepository _authRepository;

  Future<void> onIntent(AuthIntent intent) => switch (intent) {
        LoginRequested() => _login(intent),
        GuestLoginRequested() => _continueAsGuest(),
        SignUpRequested() => _signUp(intent),
        ForgotPasswordRequested() => _sendPasswordResetEmail(intent),
      };

  Future<void> _login(LoginRequested intent) async {
    safeEmit(const AuthLoading());
    final result = await _authRepository.login(email: intent.email, password: intent.password);
    result.fold(
      (failure) => safeEmit(AuthFailed(failure.message)),
      (user) => safeEmit(AuthLoginSuccess(user)),
    );
  }

  Future<void> _continueAsGuest() async {
    safeEmit(const AuthLoading());
    final result = await _authRepository.continueAsGuest();
    result.fold(
      (failure) => safeEmit(AuthFailed(failure.message)),
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
      phoneNumber: intent.phoneNumber,
      gender: intent.gender,
    );
    result.fold(
      (failure) => safeEmit(AuthFailed(failure.message)),
      (user) => safeEmit(AuthSignUpSuccess(user)),
    );
  }

  Future<void> _sendPasswordResetEmail(ForgotPasswordRequested intent) async {
    safeEmit(const AuthLoading());
    final result = await _authRepository.sendPasswordResetEmail(intent.email);
    result.fold(
      (failure) => safeEmit(AuthFailed(failure.message)),
      (_) => safeEmit(AuthPasswordResetEmailSent(intent.email)),
    );
  }
}
