import 'package:injectable/injectable.dart';
import '../../../../core/base/pagination_params.dart';
import '../../../../core/base/safe_call.dart';
import '../../../../core/domain/entities/product_entity.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/occasion_entity.dart';
import '../../domain/entities/product_details_entity.dart';
import '../../domain/entities/products_data_entity.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../data_sources/local/catalog_local_data_source.dart';
import '../data_sources/remote/catalog_remote_data_source.dart';
import '../mappers/commerce_mapper.dart';

/// Depends on the [CatalogLocalDataSource] interface, never a concrete implementation — the seam a Server-Driven Commerce needs to swap in a remote source later.
@Injectable(as: CatalogRepository)
class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl(this._dataSource, this._commerceMapper, this._remoteDataSource);

  final CommerceMapper _commerceMapper;
  final CatalogRemoteDataSource _remoteDataSource;
  final CatalogLocalDataSource _dataSource;

  @override
  Future<Result<List<CategoryEntity>>> getCategories() {
    return safeCall(() async {
      final response = await _remoteDataSource.getCategories();
      final categories = _commerceMapper.mapCategoriesResponseToEntity(response).data;
      if (categories == null) {
        throw ServerException(AppStrings.nullData);
      }
      return categories;
    },);
  }

  @override
  Future<Result<List<OccasionEntity>>> getOccasions() {
    return safeCall(() async {
      final response = await _remoteDataSource.getOccasions();
      final occasions = _commerceMapper.mapOccasionsResponseToEntity(response).data;
      if (occasions == null) {
        throw ServerException(AppStrings.nullData);
      }
      return occasions;
    },);
  }

  @override
  Future<Result<ProductsDataEntity>> getBestSellers(PaginationParams params) {
    return safeCall(() async {
      final response = await _remoteDataSource.getBestSeller(params.page, params.pageSize);
      final entity = _commerceMapper.mapProductsResponseToEntity(response);
      if (entity.data == null) {
        throw ServerException(AppStrings.nullData);
      }
      return entity.data!;
    });
  }

  @override
  Future<Result<ProductsDataEntity>> getAllProducts(PaginationParams params) {
    return safeCall(() async {
      final response = await _remoteDataSource.getAllProducts(params.page, params.pageSize);
      final entity = _commerceMapper.mapProductsResponseToEntity(response);
      if (entity.data == null) {
        throw ServerException(AppStrings.nullData);
      }
      return entity.data!;
    });
  }

  @override
  Future<Result<ProductsDataEntity>> getProductsByCategory(PaginationParams params,String categoryId) {
    return safeCall(() async {
      final response = await _remoteDataSource.getAllProducts(params.page, params.pageSize, categoryId);
      final entity = _commerceMapper.mapProductsResponseToEntity(response);
      if (entity.data == null) {
        throw ServerException(AppStrings.nullData);
      }
      return entity.data!;
    });
  }

  @override
  Future<Result<ProductsDataEntity>> getProductsByOccasion(PaginationParams params, String occasionId) {
    return safeCall(() async {
      final response = await _remoteDataSource.getAllProducts(params.page, params.pageSize, occasionId);
      final entity = _commerceMapper.mapProductsResponseToEntity(response);
      if (entity.data == null) {
        throw ServerException(AppStrings.nullData);
      }
      return entity.data!;
    });
  }

// Kept as its own try/catch rather than safeCall: the one Catalog method with a genuine special case (missing product -> NotFoundFailure).
  @override
  Future<Result<ProductDetailsEntity>> getProductById(String id) async {
    try {
      final response = await _remoteDataSource.getProductById(id);
      final entity = _commerceMapper.mapProductDetailsResponse(response);

      if (entity.data == null) {
        throw ServerException(AppStrings.nullData);
      }

      return Result.success(entity.data!);
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