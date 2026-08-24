import 'package:injectable/injectable.dart';

import '../../../../../core/domain/entities/category_entity.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repositories/catalog_repository.dart';

/// Thin, single-purpose wrapper over [CatalogRepository.getCategories], so presentation code depends only on use cases, never a repository directly.
@lazySingleton
class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  const GetCategoriesUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<List<CategoryEntity>>> call(NoParams params) {
    return _repository.getCategories();
  }
}
