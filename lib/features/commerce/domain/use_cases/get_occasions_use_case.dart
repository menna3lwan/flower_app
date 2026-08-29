import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/occasion_entity.dart';
import '../repositories/catalog_repository.dart';

/// Thin wrapper over [CatalogRepository.getOccasions].
@lazySingleton
class GetOccasionsUseCase implements UseCase<List<OccasionEntity>, NoParams> {
  const GetOccasionsUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<List<OccasionEntity>>> call(NoParams params) {
    return _repository.getOccasions();
  }
}
