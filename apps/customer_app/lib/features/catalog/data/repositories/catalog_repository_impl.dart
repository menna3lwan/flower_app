import '../../../../core/domain/entities/category_entity.dart';
import '../../../../core/domain/entities/occasion_entity.dart';
import '../../../../core/domain/entities/product_entity.dart';
import 'package:core/error/exceptions.dart';
import 'package:core/error/failures.dart';
import 'package:core/result/result.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_local_data_source.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(this._dataSource);

  final CatalogLocalDataSource _dataSource;

  @override
  Future<Result<List<CategoryEntity>>> getCategories() async {
    try {
      return Result.success(await _dataSource.getCategories());
    } catch (_) {
      return const Result.failure(UnexpectedFailure());
    }
  }

  @override
  Future<Result<List<OccasionEntity>>> getOccasions() async {
    try {
      return Result.success(await _dataSource.getOccasions());
    } catch (_) {
      return const Result.failure(UnexpectedFailure());
    }
  }

  @override
  Future<Result<List<ProductEntity>>> getBestSellers() async {
    try {
      final products = await _dataSource.getAllProducts();
      final sorted = [...products]..sort((a, b) => b.rating.compareTo(a.rating));
      return Result.success(sorted);
    } catch (_) {
      return const Result.failure(UnexpectedFailure());
    }
  }

  @override
  Future<Result<List<ProductEntity>>> getAllProducts() async {
    try {
      return Result.success(await _dataSource.getAllProducts());
    } catch (_) {
      return const Result.failure(UnexpectedFailure());
    }
  }

  @override
  Future<Result<List<ProductEntity>>> getProductsByCategory(String categoryId) async {
    try {
      final products = await _dataSource.getAllProducts();
      return Result.success(products.where((p) => p.categoryId == categoryId).toList());
    } catch (_) {
      return const Result.failure(UnexpectedFailure());
    }
  }

  @override
  Future<Result<List<ProductEntity>>> getProductsByOccasion(String occasionId) async {
    try {
      final ids = await _dataSource.occasionProductIds(occasionId);
      final products = await _dataSource.getAllProducts();
      return Result.success(products.where((p) => ids.contains(p.id)).toList());
    } catch (_) {
      return const Result.failure(UnexpectedFailure());
    }
  }

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
  Future<Result<List<ProductEntity>>> searchProducts(String query) async {
    try {
      final products = await _dataSource.getAllProducts();
      final normalized = query.trim().toLowerCase();
      if (normalized.isEmpty) return const Result.success([]);
      return Result.success(
        products.where((p) => p.name.toLowerCase().contains(normalized)).toList(),
      );
    } catch (_) {
      return const Result.failure(UnexpectedFailure());
    }
  }
}
