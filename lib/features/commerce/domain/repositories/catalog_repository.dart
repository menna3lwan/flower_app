
import '../../../../core/base/pagination_params.dart';
import '../../../../core/domain/entities/product_entity.dart';
import '../../../../core/result/result.dart';
import '../entities/category_entity.dart';
import '../entities/occasion_entity.dart';
import '../entities/product_details_entity.dart';
import '../entities/products_data_entity.dart';

/// Shared catalog contract used by Home, Categories, Product Details and Search — one repository instead of four to keep a single dummy dataset in sync.
abstract interface class CatalogRepository {
  Future<Result<List<CategoryEntity>>> getCategories();

  Future<Result<List<OccasionEntity>>> getOccasions();

  Future<Result<ProductsDataEntity>> getBestSellers(PaginationParams params);

  Future<Result<ProductsDataEntity>> getAllProducts(PaginationParams params);

  Future<Result<ProductsDataEntity>> getProductsByCategory(
    PaginationParams params,
    String categoryId,
  );

  Future<Result<ProductsDataEntity>> getProductsByOccasion(
    PaginationParams params,
    String occasionId,
  );

  Future<Result<ProductDetailsEntity>> getProductById(String id);

  Future<Result<List<ProductEntity>>> searchProducts(String query);
}
