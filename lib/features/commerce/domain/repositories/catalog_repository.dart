import 'package:customer_app/core/domain/entities/product_entity.dart';
import 'package:customer_app/core/result/result.dart';
import '../entities/category_entity.dart';
import '../entities/occasion_entity.dart';

/// Shared catalog contract used by Home, Categories, Product Details and Search — one repository instead of four to keep a single dummy dataset in sync.
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
