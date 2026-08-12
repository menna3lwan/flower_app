import '../../../../core/domain/entities/category_entity.dart';
import '../../../../core/domain/entities/occasion_entity.dart';
import '../../../../core/domain/entities/product_entity.dart';
import '../../../../core/result/result.dart';

/// Shared catalog contract used by Home, Categories, Product details and Search — one repository, one dataset.
abstract interface class CatalogRepository {
  Future<Result<List<CategoryEntity>>> getCategories();

  Future<Result<List<OccasionEntity>>> getOccasions();

  Future<Result<List<ProductEntity>>> getBestSellers();

  Future<Result<List<ProductEntity>>> getAllProducts();

  Future<Result<List<ProductEntity>>> getProductsByCategory(String categoryId);

  Future<Result<List<ProductEntity>>> getProductsByOccasion(String occasionId);

  Future<Result<ProductEntity>> getProductById(String id);

  Future<Result<List<ProductEntity>>> searchProducts(String query);
}
