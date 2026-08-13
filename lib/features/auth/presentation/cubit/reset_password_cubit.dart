import 'package:customer_app/core/base/base_cubit.dart';

import '../../domain/repositories/auth_repository.dart';
import '../state/reset_password_state.dart';

/// Kept separate from [AuthCubit]: Reset Password isn't part of the
/// Login/Sign Up/Forgot Password journey the task scoped `AuthCubit`
/// to — it's reached only after a password-reset email + code have
/// already been verified, and it's also the same screen a signed-in
/// user would reach from Profile later. Folding it into `AuthCubit`
/// would mix "not yet authenticated" and "already authenticated"
/// concerns into one Cubit for no real benefit.
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
