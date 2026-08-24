import 'package:injectable/injectable.dart';

import '../../../../../core/base/safe_call.dart';
import '../../../../../core/domain/entities/category_entity.dart';
import '../../../../../core/domain/entities/occasion_entity.dart';
import '../../../../../core/domain/entities/product_entity.dart';
import 'package:customer_app/core/error/exceptions.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_local_data_source.dart';

/// Depends on the [CatalogLocalDataSource] interface, never a concrete implementation — the seam a Server-Driven Commerce needs to swap in a remote source later.
@LazySingleton(as: CatalogRepository)
class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(this._dataSource);

  final CatalogLocalDataSource _dataSource;

  @override
  Future<Result<List<CategoryEntity>>> getCategories() {
    return safeCall(() => _dataSource.getCategories());
  }

  @override
  Future<Result<List<OccasionEntity>>> getOccasions() {
    return safeCall(() => _dataSource.getOccasions());
  }

  @override
  Future<Result<List<ProductEntity>>> getBestSellers() {
    return safeCall(() async {
      final products = await _dataSource.getAllProducts();
      return [...products]..sort((a, b) => b.rating.compareTo(a.rating));
    });
  }

  @override
  Future<Result<List<ProductEntity>>> getAllProducts() {
    return safeCall(() => _dataSource.getAllProducts());
  }

  @override
  Future<Result<List<ProductEntity>>> getProductsByCategory(
      String categoryId) {
    return safeCall(() async {
      final products = await _dataSource.getAllProducts();
      return products.where((p) => p.categoryId == categoryId).toList();
    });
  }

  @override
  Future<Result<List<ProductEntity>>> getProductsByOccasion(
      String occasionId) {
    return safeCall(() async {
      final ids = await _dataSource.occasionProductIds(occasionId);
      final products = await _dataSource.getAllProducts();
      return products.where((p) => ids.contains(p.id)).toList();
    });
  }

  // Kept as its own try/catch rather than safeCall: the one Catalog method with a genuine special case (missing product -> NotFoundFailure).
  @override
  Future<Result<ProductEntity>> getProductById(String id) async {
    try {
      return Result.success(await _dataSource.getProductById(id));
    } on ServerException catch (e) {
      return Result.failure(NotFoundFailure(e.message));
    } catch (_) {
      return const Result.failure(UnexpectedFailure());
    }
  }

  @override
  Future<Result<List<ProductEntity>>> searchProducts(String query) {
    return safeCall(() async {
      final normalized = query.trim().toLowerCase();
      if (normalized.isEmpty) return const <ProductEntity>[];
      final products = await _dataSource.getAllProducts();
      return products
          .where((p) => p.name.toLowerCase().contains(normalized))
          .toList();
    });
  }
}
