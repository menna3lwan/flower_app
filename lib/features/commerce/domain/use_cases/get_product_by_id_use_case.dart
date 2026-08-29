import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_details_entity.dart';
import '../repositories/catalog_repository.dart';

/// Thin, single-purpose wrapper over [CatalogRepository.getProductById]. See `GetCategoriesUseCase`'s doc comment for why this exists.
@injectable
class GetProductByIdUseCase implements UseCase<ProductDetailsEntity, String> {
  const GetProductByIdUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<ProductDetailsEntity>> call(String id) {
    return _repository.getProductById(id);
  }
}
