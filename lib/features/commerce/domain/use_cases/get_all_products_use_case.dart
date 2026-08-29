import 'package:injectable/injectable.dart';
import '../../../../core/base/pagination_params.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/products_data_entity.dart';
import '../repositories/catalog_repository.dart';

/// Thin, single-purpose wrapper over [CatalogRepository.getBestSellers]. See [GetCategoriesUseCase]'s doc comment for why this exists.
@injectable
class GetAllProductsUseCase implements UseCase<ProductsDataEntity, PaginationParams> {
  const GetAllProductsUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<ProductsDataEntity>> call(PaginationParams params) async {
    return await _repository.getAllProducts(params);
  }
}
