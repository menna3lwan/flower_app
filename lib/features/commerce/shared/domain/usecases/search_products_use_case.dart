import 'package:injectable/injectable.dart';

import '../../../../../core/domain/entities/product_entity.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repositories/catalog_repository.dart';

/// Thin, single-purpose wrapper over [CatalogRepository.searchProducts]. See `GetCategoriesUseCase`'s doc comment for why this exists.
@lazySingleton
class SearchProductsUseCase implements UseCase<List<ProductEntity>, String> {
  const SearchProductsUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<List<ProductEntity>>> call(String query) {
    return _repository.searchProducts(query);
  }
}
