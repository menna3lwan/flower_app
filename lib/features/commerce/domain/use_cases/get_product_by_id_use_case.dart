import 'package:injectable/injectable.dart';

import '../../../../core/domain/entities/product_entity.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/catalog_repository.dart';

/// Thin wrapper over [CatalogRepository.getProductById].
@lazySingleton
class GetProductByIdUseCase implements UseCase<ProductEntity, String> {
  const GetProductByIdUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<ProductEntity>> call(String id) {
    return _repository.getProductById(id);
  }
}
