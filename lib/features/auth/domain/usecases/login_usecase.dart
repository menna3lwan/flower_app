import 'package:injectable/injectable.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/result/result.dart';
import '../repositories/auth_repository.dart';

/// Thin, single-purpose wrapper over [AuthRepository.login] — exists so
/// [AuthCubit] depends only on use cases (per the DI flow: GetIt -> API
/// Service -> Data Source -> Repository -> Use Case -> Cubit), never on
/// a repository directly. Deliberately does nothing beyond delegating:
/// there is no extra business rule for Login today, and this class is
/// not the place to invent one.
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
