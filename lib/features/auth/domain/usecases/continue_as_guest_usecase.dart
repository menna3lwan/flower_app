import 'package:injectable/injectable.dart';

import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/result/result.dart';
import '../repositories/auth_repository.dart';

/// Thin wrapper over [AuthRepository.continueAsGuest].
@lazySingleton
class ContinueAsGuestUseCase {
  const ContinueAsGuestUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<UserEntity>> call() => _repository.continueAsGuest();
}
