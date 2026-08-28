import 'package:customer_app/core/base/pagination_params.dart';
import 'package:customer_app/core/error/exceptions.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/features/commerce/constants/enums/product_status.dart';
import 'package:customer_app/features/commerce/data/data_sources/local/catalog_local_data_source.dart';
import 'package:customer_app/features/commerce/data/data_sources/remote/catalog_remote_data_source.dart';
import 'package:customer_app/features/commerce/data/mappers/commerce_mapper.dart';
import 'package:customer_app/features/commerce/data/models/categories_response.dart';
import 'package:customer_app/features/commerce/data/models/occasions_response.dart';
import 'package:customer_app/features/commerce/data/models/product_details_response.dart';
import 'package:customer_app/features/commerce/data/models/products_response.dart';
import 'package:customer_app/features/commerce/data/repositories/catalog_repository_impl.dart';
import 'package:customer_app/features/commerce/domain/entities/categories_response_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/category_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/occasion_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/occasions_response_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/pagination_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/product_details_response_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/products_data_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/products_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'catalog_repository_impl_test.mocks.dart';

@GenerateMocks([
  CatalogLocalDataSource,
  CatalogRemoteDataSource,
  CommerceMapper,
])
void main() {
  late MockCatalogLocalDataSource catalogLocalDataSource;
  late MockCatalogRemoteDataSource catalogRemoteDataSource;
  late MockCommerceMapper commerceMapper;

  late CatalogRepositoryImpl catalogRepository;

  setUp(() {
    catalogLocalDataSource = MockCatalogLocalDataSource();
    catalogRemoteDataSource = MockCatalogRemoteDataSource();
    commerceMapper = MockCommerceMapper();

    catalogRepository = CatalogRepositoryImpl(
      catalogLocalDataSource,
      commerceMapper,
      catalogRemoteDataSource,
    );
  });

  group('getProductById', () {
    const productId = 'product-1';

    test('should return Success with ProductDetailsEntity', () async {
      const productDetailsResponse = ProductDetailsResponse();
      const productDetailsEntity = ProductDetailsEntity(id: productId, status: ProductStatus.inStock);
      const mappedResponse = ProductDetailsResponseEntity(data: productDetailsEntity, status: true, message: 'Success');

      when(catalogRemoteDataSource.getProductById(productId)).thenAnswer((_) async => productDetailsResponse);
      when(commerceMapper.mapProductDetailsResponse(productDetailsResponse)).thenReturn(mappedResponse);

      final result = await catalogRepository.getProductById(productId);

      expect(result, isA<Success<ProductDetailsEntity>>());
      result.fold((_) => fail('Expected Success'), (data) {
        expect(data, productDetailsEntity);
      });
      verify(catalogRemoteDataSource.getProductById(productId)).called(1);
      verify(commerceMapper.mapProductDetailsResponse(productDetailsResponse)).called(1);
    });

    test('should return NotFoundFailure when ServerException is thrown', () async {
      when(catalogRemoteDataSource.getProductById(productId)).thenThrow(ServerException('Product not found'));

      final result = await catalogRepository.getProductById(productId);

      expect(result, isA<ResultFailure<ProductDetailsEntity>>());
      result.fold(
        (failure) {
          expect(failure, isA<NotFoundFailure>());
          expect((failure as NotFoundFailure).message, 'Product not found');
        },
        (_) => fail('Expected failure but got success'),
      );
      verify(catalogRemoteDataSource.getProductById(productId)).called(1);
    });

    test('should return UnexpectedFailure for other exceptions', () async {
      when(catalogRemoteDataSource.getProductById(productId)).thenThrow(Exception('Some error'));

      final result = await catalogRepository.getProductById(productId);

      expect(result, isA<ResultFailure<ProductDetailsEntity>>());
      result.fold(
        (failure) {
          expect(failure, isA<UnexpectedFailure>());
        },
        (_) => fail('Expected failure but got success'),
      );
      verify(catalogRemoteDataSource.getProductById(productId)).called(1);
    });
  });

  group('getBestSellers', () {
    test('should return paginated list of products from remote data source', () async {
      final mockProductsResponse = ProductsResponse();
      const mockProductsDataEntity = ProductsDataEntity(items: [], pagination: PaginationEntity(page: 1, pageSize: 10, totalCount: 0, totalPages: 1, hasNextPage: false, hasPreviousPage: false));
      const mockResponseEntity = ProductsResponseEntity(status: true, data: mockProductsDataEntity, errors: [], code: 200, message: '');

      when(catalogRemoteDataSource.getBestSeller(1, 10)).thenAnswer((_) async => mockProductsResponse);
      when(commerceMapper.mapProductsResponseToEntity(mockProductsResponse)).thenReturn(mockResponseEntity);

      final result = await catalogRepository.getBestSellers(const PaginationParams(page: 1, pageSize: 10));

      expect(result, isA<Success<ProductsDataEntity>>());
      result.fold((_) => fail('Expected Success'), (data) {
        expect(data, mockProductsDataEntity);
      });
      verify(catalogRemoteDataSource.getBestSeller(1, 10)).called(1);
    });
  });

  group('getAllProducts', () {
    test('should return paginated list of products from remote data source', () async {
      final mockProductsResponse = ProductsResponse();
      const mockProductsDataEntity = ProductsDataEntity(items: [], pagination: PaginationEntity(page: 1, pageSize: 10, totalCount: 0, totalPages: 1, hasNextPage: false, hasPreviousPage: false));
      const mockResponseEntity = ProductsResponseEntity(status: true, data: mockProductsDataEntity, errors: [], code: 200, message: '');

      when(catalogRemoteDataSource.getAllProducts(1, 10)).thenAnswer((_) async => mockProductsResponse);
      when(commerceMapper.mapProductsResponseToEntity(mockProductsResponse)).thenReturn(mockResponseEntity);

      final result = await catalogRepository.getAllProducts(const PaginationParams(page: 1, pageSize: 10));

      expect(result, isA<Success<ProductsDataEntity>>());
      result.fold((_) => fail('Expected Success'), (data) {
        expect(data, mockProductsDataEntity);
      });
    });
  });

  group('getProductsByCategory', () {
    test('should return products filtered by categoryId', () async {
      const categoryId = 'c1';
      final mockProductsResponse = ProductsResponse();
      const mockProductsDataEntity = ProductsDataEntity(items: [], pagination: PaginationEntity(page: 1, pageSize: 10, totalCount: 0, totalPages: 1, hasNextPage: false, hasPreviousPage: false));
      const mockResponseEntity = ProductsResponseEntity(status: true, data: mockProductsDataEntity, errors: [], code: 200, message: '');

      when(catalogRemoteDataSource.getAllProducts(1, 10, categoryId)).thenAnswer((_) async => mockProductsResponse);
      when(commerceMapper.mapProductsResponseToEntity(mockProductsResponse)).thenReturn(mockResponseEntity);

      final result = await catalogRepository.getProductsByCategory(const PaginationParams(page: 1, pageSize: 10), categoryId);

      expect(result, isA<Success<ProductsDataEntity>>());
      result.fold((_) => fail('Expected Success'), (data) {
        expect(data, mockProductsDataEntity);
      });
      verify(catalogRemoteDataSource.getAllProducts(1, 10, categoryId)).called(1);
    });
  });

  group('getCategories', () {
    test('should return list of categories from remote data source', () async {
      final mockResponse = CategoriesResponse(status: true, data: [], errors: [], code: 200, message: 'ok');
      final categories = [
        const CategoryEntity(id: 'c1', name: 'Cat 1', iconName: 'icon1'),
      ];
      final mockResponseEntity = CategoriesResponseEntity(status: true, data: categories, errors: [], code: 200, message: 'ok');

      when(catalogRemoteDataSource.getCategories()).thenAnswer((_) async => mockResponse);
      when(commerceMapper.mapCategoriesResponseToEntity(mockResponse)).thenReturn(mockResponseEntity);

      final result = await catalogRepository.getCategories();

      expect(result, isA<Success<List<CategoryEntity>>>());
      result.fold((_) => fail('Expected Success'), (data) {
        expect(data, categories);
      });
      verify(catalogRemoteDataSource.getCategories()).called(1);
      verify(commerceMapper.mapCategoriesResponseToEntity(mockResponse)).called(1);
    });
  });

  group('getOccasions', () {
    test('should return list of occasions from remote data source', () async {
      final mockResponse = OccasionsResponse(status: true, data: [], errors: [], code: 200, message: 'ok');
      final occasions = [
        const OccasionEntity(id: 'o1', name: 'Occ 1', imageUrl: 'url1'),
      ];
      final mockResponseEntity = OccasionsResponseEntity(status: true, data: occasions, errors: [], code: 200, message: 'ok');

      when(catalogRemoteDataSource.getOccasions()).thenAnswer((_) async => mockResponse);
      when(commerceMapper.mapOccasionsResponseToEntity(mockResponse)).thenReturn(mockResponseEntity);

      final result = await catalogRepository.getOccasions();

      expect(result, isA<Success<List<OccasionEntity>>>());
      result.fold((_) => fail('Expected Success'), (data) {
        expect(data, occasions);
      });
      verify(catalogRemoteDataSource.getOccasions()).called(1);
      verify(commerceMapper.mapOccasionsResponseToEntity(mockResponse)).called(1);
    });
  });

  group('getProductsByOccasion', () {
    test('should return products filtered by occasionId from remote data source', () async {
      const occasionId = 'o1';
      final mockProductsResponse = ProductsResponse();
      const mockProductsDataEntity = ProductsDataEntity(items: [], pagination: PaginationEntity(page: 1, pageSize: 10, totalCount: 0, totalPages: 1, hasNextPage: false, hasPreviousPage: false));
      const mockResponseEntity = ProductsResponseEntity(status: true, data: mockProductsDataEntity, errors: [], code: 200, message: '');

      when(catalogRemoteDataSource.getAllProducts(1, 10, occasionId)).thenAnswer((_) async => mockProductsResponse);
      when(commerceMapper.mapProductsResponseToEntity(mockProductsResponse)).thenReturn(mockResponseEntity);

      final result = await catalogRepository.getProductsByOccasion(const PaginationParams(page: 1, pageSize: 10), occasionId);

      expect(result, isA<Success<ProductsDataEntity>>());
      result.fold((_) => fail('Expected Success'), (data) {
        expect(data, mockProductsDataEntity);
      });
      verify(catalogRemoteDataSource.getAllProducts(1, 10, occasionId)).called(1);
      verify(commerceMapper.mapProductsResponseToEntity(mockProductsResponse)).called(1);
    });
  });

}