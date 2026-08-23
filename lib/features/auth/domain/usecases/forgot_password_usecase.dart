import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../repositories/auth_repository.dart';

/// Thin wrapper over [AuthRepository.sendPasswordResetEmail] — see
/// [LoginUseCase]'s doc comment (in `login_usecase.dart`) for why this
/// layer exists.
@lazySingleton
class ForgotPasswordUseCase {
  const ForgotPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call(String email) =>
      _repository.sendPasswordResetEmail(email);
}
