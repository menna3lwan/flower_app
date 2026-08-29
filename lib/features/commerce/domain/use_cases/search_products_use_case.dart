import 'package:injectable/injectable.dart';

import '../../../../core/domain/entities/product_entity.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/catalog_repository.dart';

/// Thin wrapper over [CatalogRepository.searchProducts].
@lazySingleton
class SearchProductsUseCase implements UseCase<List<ProductEntity>, String> {
  const SearchProductsUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<List<ProductEntity>>> call(String query) {
    return _repository.searchProducts(query);
  }
}
