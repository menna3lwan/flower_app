import 'package:customer_app/core/error/exceptions.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/features/commerce/constants/enums/product_status.dart';
import 'package:customer_app/features/commerce/data/data_sources/local/catalog_local_data_source.dart';
import 'package:customer_app/features/commerce/data/data_sources/remote/catalog_remote_data_source.dart';
import 'package:customer_app/features/commerce/data/mappers/commerce_mapper.dart';
import 'package:customer_app/features/commerce/data/models/product_details_response.dart';
import 'package:customer_app/features/commerce/data/repositories/catalog_repository_impl.dart';
import 'package:customer_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/product_details_response_entity.dart';
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
}