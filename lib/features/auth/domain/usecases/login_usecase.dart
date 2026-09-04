import 'package:injectable/injectable.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/result/result.dart';
import '../repositories/auth_repository.dart';

/// Thin wrapper over [AuthRepository.login].
@lazySingleton
class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<UserEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
