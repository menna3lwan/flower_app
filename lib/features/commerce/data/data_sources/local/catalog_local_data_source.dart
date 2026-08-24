import 'package:customer_app/core/domain/entities/product_entity.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/occasion_entity.dart';

/// Contract for Commerce's catalog data source. [CatalogLocalDataSourceImpl] (in `catalog_local_data_source_impl.dart`) is the only implementation today, since no real Catalog backend/API exists yet — a future remote implementation swaps in behind this same interface without touching use cases or the Cubit.
abstract interface class CatalogLocalDataSource {
  Future<List<CategoryEntity>> getCategories();
  Future<List<OccasionEntity>> getOccasions();
  Future<List<ProductEntity>> getAllProducts();
  Future<ProductEntity> getProductById(String id);

  Future<List<String>> occasionProductIds(String occasionId);
}
