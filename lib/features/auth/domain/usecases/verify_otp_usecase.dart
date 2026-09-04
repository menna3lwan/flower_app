import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../repositories/auth_repository.dart';

/// Thin wrapper over [AuthRepository.verifyCode].
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
