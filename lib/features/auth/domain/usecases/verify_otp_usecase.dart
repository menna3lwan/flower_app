import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../repositories/auth_repository.dart';

/// Thin wrapper over [AuthRepository.verifyCode] — see [LoginUseCase]'s doc comment for why this layer exists.
@lazySingleton
class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  /// Returns the one-time `resetToken` [ResetPasswordUseCase] needs — see [AuthRepository.verifyCode].
  Future<Result<String>> call({
    required String email,
    required String code,
  }) {
    return _repository.verifyCode(email: email, code: code);
  }
}
