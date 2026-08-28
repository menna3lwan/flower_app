import 'package:customer_app/core/constants/app_assets.dart';
import 'package:customer_app/features/commerce/data/data_sources/remote/catalog_remote_data_source_impl.dart';
import 'package:customer_app/features/commerce/data/models/product_details_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CatalogRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = CatalogRemoteDataSourceImpl();
  });

  group('CatalogRemoteDataSourceImpl', () {
    group('getProductById', () {
      test('should return successful product details response', () async {
        // Arrange
        const productId = '101';

        // Act
        final result = await dataSource.getProductById(productId);

        // Assert
        expect(result, isA<ProductDetailsResponse>());
        expect(result.status, isTrue);
        expect(result.message, 'Success');
        expect(result.code, 200);
        expect(result.errors, isEmpty);

        expect(result.data, isNotNull);
        expect(result.data!.id, '101');
        expect(result.data!.name, '15 Pink Rose Bouquet');
        expect(result.data!.imageUrls, [
          AppAssets.flower1,
          AppAssets.flower1,
          AppAssets.flower1,
          AppAssets.flower1,
        ]);
        expect(result.data!.discountedPrice, 1500);
        expect(result.data!.originalPrice, 1600);
        expect(result.data!.discountPercentage, isNull);
        expect(result.data!.isOutOfStock, isFalse);

        expect(result.data!.includes, hasLength(2));
        expect(result.data!.includes?[0], 'Pink roses');
        expect(result.data!.includes?[1], 'White wrap');
        expect(result.data!.stockQuantity, 20);
      });

      test(
        'should return the same product details regardless of product id',
        () async {
          // Arrange
          const firstId = '1';
          const secondId = '999';

          // Act
          final firstResult = await dataSource.getProductById(firstId);
          final secondResult = await dataSource.getProductById(secondId);

          // Assert
          expect(firstResult.data!.id, secondResult.data!.id);
          expect(firstResult.data!.name, secondResult.data!.name);
        },
      );
    });

    group('getBestSeller', () {
      test('should return paginated list correctly for page 1', () async {
        // Act
        final result = await dataSource.getBestSeller(1, 15);

        // Assert
        expect(result.status, isTrue);
        expect(result.code, 200);
        expect(result.data!.items, hasLength(15));
        expect(result.data!.pageNumber, 1);
        expect(result.data!.pageSize, 15);
        expect(result.data!.totalCount, 50);
        expect(result.data!.hasNextPage, isTrue);
      });

      test('should return paginated list correctly for last page', () async {
        // Act
        final result = await dataSource.getBestSeller(4, 15);

        // Assert
        expect(result.status, isTrue);
        expect(result.data!.items, hasLength(5)); // 50 % 15 = 5
        expect(result.data!.pageNumber, 4);
        expect(result.data!.hasNextPage, isFalse);
      });

      test('should return empty list if page is beyond total pages', () async {
        // Act
        final result = await dataSource.getBestSeller(5, 15);

        // Assert
        expect(result.status, isTrue);
        expect(result.data!.items, isEmpty);
        expect(result.data!.pageNumber, 5);
        expect(result.data!.hasNextPage, isFalse);
      });
    });

    group('unimplemented methods', () {

      test('occasionProductIds should throw UnimplementedError', () {
        expect(
          () => dataSource.occasionProductIds('1'),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });
  });
}
