import 'package:core/base/base_cubit.dart';
import '../../../domain/repositories/auth_repository.dart';
import './login_state.dart';

/// Orchestrates the Login screen: calls [AuthRepository], maps the
/// [Result] to a [LoginState]. No validation/business rules live here —
/// field-level validation stays in `Validators` + `TextFormField`, and
/// credential verification stays in the repository/data source.
class LoginCubit extends BaseCubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginInitial());

  final AuthRepository _authRepository;

  Future<void> login({required String email, required String password}) async {
    safeEmit(const LoginSubmitting());
    final result = await _authRepository.login(email: email, password: password);
    result.fold(
      (failure) => safeEmit(LoginFailed(failure.message)),
      (user) => safeEmit(LoginSuccess(user)),
    );
  }

  Future<void> continueAsGuest() async {
    safeEmit(const LoginSubmitting());
    final result = await _authRepository.continueAsGuest();
    result.fold(
      (failure) => safeEmit(LoginFailed(failure.message)),
      (user) => safeEmit(LoginSuccess(user)),
    );
  }
}
