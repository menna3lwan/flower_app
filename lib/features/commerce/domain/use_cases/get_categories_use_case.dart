import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/catalog_repository.dart';

/// Thin wrapper over [CatalogRepository.getCategories].
@lazySingleton
class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  const GetCategoriesUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<List<CategoryEntity>>> call(NoParams params) {
    return _repository.getCategories();
  }
}
