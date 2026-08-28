import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/products_data_entity.dart';
import '../repositories/catalog_repository.dart';

/// Thin, single-purpose wrapper over [CatalogRepository.getProductsByCategory] — `Params` is the plain `categoryId` string, no dedicated params class (YAGNI).
@lazySingleton
class GetProductsByCategoryUseCase implements UseCase<ProductsDataEntity, ParamsWithPagination<String>> {
  const GetProductsByCategoryUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<ProductsDataEntity>> call(ParamsWithPagination<String> params) async {
    return await _repository.getProductsByCategory(params.pagination, params.param!);
  }

}

