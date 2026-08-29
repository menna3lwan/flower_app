import 'package:injectable/injectable.dart';

import '../../../../core/domain/entities/product_entity.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/catalog_repository.dart';

/// Thin wrapper over [CatalogRepository.getProductsByCategory].
@lazySingleton
class GetProductsByCategoryUseCase
    implements UseCase<List<ProductEntity>, String> {
  const GetProductsByCategoryUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<List<ProductEntity>>> call(String categoryId) {
    return _repository.getProductsByCategory(categoryId);
  }
}
