import '../../../../../core/base/base_cubit.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends BaseCubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._authRepository) : super(const ForgotPasswordInitial());

  final AuthRepository _authRepository;

  Future<void> sendResetEmail(String email) async {
    safeEmit(const ForgotPasswordSubmitting());
    final result = await _authRepository.sendPasswordResetEmail(email);
    result.fold(
      (failure) => safeEmit(ForgotPasswordFailed(failure.message)),
      (_) => safeEmit(const ForgotPasswordEmailSent()),
    );
  }
}
