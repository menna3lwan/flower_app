import 'package:injectable/injectable.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/result/result.dart';
import '../repositories/auth_repository.dart';

/// Thin wrapper over [AuthRepository.signUp] — see [LoginUseCase]'s doc
/// comment for why this layer exists.
@lazySingleton
class SignUpUseCase {
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<UserEntity>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required Gender gender,
  }) {
    return _repository.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
      gender: gender,
    );
  }
}
