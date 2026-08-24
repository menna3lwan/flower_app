import 'package:injectable/injectable.dart';

import '../../../../../core/domain/entities/product_entity.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repositories/catalog_repository.dart';

/// Thin, single-purpose wrapper over [CatalogRepository.getProductById]. See `GetCategoriesUseCase`'s doc comment for why this exists.
@lazySingleton
class GetProductByIdUseCase implements UseCase<ProductEntity, String> {
  const GetProductByIdUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<ProductEntity>> call(String id) {
    return _repository.getProductById(id);
  }
}
