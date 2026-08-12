import 'package:core/base/base_cubit.dart';
import '../../../domain/repositories/auth_repository.dart';
import './reset_password_state.dart';

class ResetPasswordCubit extends BaseCubit<ResetPasswordState> {
  ResetPasswordCubit(this._authRepository) : super(const ResetPasswordInitial());

  final AuthRepository _authRepository;

  Future<void> resetPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    safeEmit(const ResetPasswordSubmitting());
    final result = await _authRepository.resetPassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    result.fold(
      (failure) => safeEmit(ResetPasswordFailed(failure.message)),
      (_) => safeEmit(const ResetPasswordSuccess()),
    );
  }
}
