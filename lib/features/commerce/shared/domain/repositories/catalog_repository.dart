import '../../../../core/domain/entities/category_entity.dart';
import '../../../../core/domain/entities/occasion_entity.dart';
import '../../../../core/domain/entities/product_entity.dart';
import 'package:customer_app/core/result/result.dart';

/// Shared catalog contract used by the Home, Categories, Product details
/// and Search features.
///
/// A single repository (backed by a single dummy data source) is used
/// here — rather than one per feature — because all four features query
/// the exact same underlying product/category dataset. Splitting it four
/// ways would mean four copies of the same dummy catalog to keep in sync,
/// which directly violates Single Source of Truth.
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
