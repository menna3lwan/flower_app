import 'package:injectable/injectable.dart';

import '../../../../core/domain/entities/product_entity.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/catalog_repository.dart';

/// Thin wrapper over [CatalogRepository.getBestSellers].
@lazySingleton
class GetBestSellersUseCase implements UseCase<List<ProductEntity>, NoParams> {
  const GetBestSellersUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<List<ProductEntity>>> call(NoParams params) {
    return _repository.getBestSellers();
  }
}
