import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/products_data_entity.dart';
import '../repositories/catalog_repository.dart';

/// Thin, single-purpose wrapper over [CatalogRepository.getProductsByOccasion]. See `GetCategoriesUseCase`'s doc comment for why this exists.
@injectable
class GetProductsByOccasionUseCase
    implements UseCase<ProductsDataEntity, ParamsWithPagination<String>> {
  const GetProductsByOccasionUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<ProductsDataEntity>> call(ParamsWithPagination<String> params) {
    return _repository.getProductsByOccasion(params.pagination, params.param!);
  }
}
