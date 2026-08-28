import 'package:customer_app/features/commerce/constants/enums/product_status.dart';
import 'package:customer_app/features/commerce/data/mappers/commerce_mapper.dart';
import 'package:customer_app/features/commerce/data/models/categories_response.dart';
import 'package:customer_app/features/commerce/data/models/category_dto.dart';
import 'package:customer_app/features/commerce/data/models/category_response.dart';
import 'package:customer_app/features/commerce/data/models/occasion_dto.dart';
import 'package:customer_app/features/commerce/data/models/occasions_response.dart';
import 'package:customer_app/features/commerce/data/models/product_details_data_dto.dart';
import 'package:customer_app/features/commerce/data/models/product_details_response.dart';
import 'package:customer_app/features/commerce/data/models/product_item_dto.dart';
import 'package:customer_app/features/commerce/data/models/products_data_dto.dart';
import 'package:customer_app/features/commerce/data/models/products_response.dart';
import 'package:customer_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/product_details_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CommerceMapper mapper;

  setUp(() {
    mapper = const CommerceMapper();
  });

  group('CommerceMapper', () {
    group('mapProductDetails', () {
      test('should map ProductDetailsDataDTO to ProductDetailsEntity', () {
        // Arrange
        const dto = ProductDetailsDataDTO(
          id: '101',
          name: '15 Pink Rose Bouquet',
          imageUrls: ['flower.png', 'flower2.png'],
          discountedPrice: 1500,
          originalPrice: 1600,
          discountPercentage: 6.25,
          isOutOfStock: false,
          description: 'Pink roses bouquet',
          includes: [
            'Pink roses',
            'White wrap',
          ],
          stockQuantity: 10,
        );

        // Act
        final result = mapper.mapProductDetails(dto);

        // Assert
        expect(result, isA<ProductDetailsEntity>());
        expect(result.id, '101');
        expect(result.name, '15 Pink Rose Bouquet');
        expect(result.imageUrl, 'flower.png');
        expect(result.currency, 'EGP');
        expect(result.price, 1500.0);
        expect(result.originalPrice, 1600.0);
        expect(result.discountPercentage, 6.25);

        expect(
          result.status,
          ProductStatus.inStock,
        );

        expect(
          result.images,
          [
            'flower.png',
            'flower2.png',
          ],
        );

        expect(result.description, 'Pink roses bouquet');

        expect(result.includes, isNotNull);
        expect(result.includes, hasLength(2));

        expect(result.includes![0].name, 'Pink roses');
        expect(result.includes![0].quantity, 10);

        expect(result.includes![1].name, 'White wrap');
        expect(result.includes![1].quantity, 10);

        expect(result.categoryId, isNull);
        expect(result.occasionIds, isNull);
      });

      test('should preserve double original price and discounted price', () {
        // Arrange
        const dto = ProductDetailsDataDTO(
          id: '1',
          name: 'Product',
          imageUrls: ['image.png'],
          discountedPrice: 1500,
          originalPrice: 1600.75,
          isOutOfStock: false,
        );

        // Act
        final result = mapper.mapProductDetails(dto);

        // Assert
        expect(result.originalPrice, 1600.75);
        expect(result.price, 1500.0);
        expect(result.price, isA<double>());
      });
    });

    group('mapProductDetailsResponse', () {
      test('should map response with product data correctly', () {
        // Arrange
        const response = ProductDetailsResponse(
          data: ProductDetailsDataDTO(
            id: '101',
            name: 'Pink Rose Bouquet',
            imageUrls: ['flower.png'],
            discountedPrice: 1500,
            originalPrice: 1600,
            discountPercentage: null,
            isOutOfStock: false,
            description: 'Beautiful bouquet',
            includes: [
              'Pink roses',
            ],
            stockQuantity: 10,
          ),
          status: true,
          message: 'Success',
          code: 200,
          errors: [],
        );

        // Act
        final result = mapper.mapProductDetailsResponse(response);

        // Assert
        expect(result, isA<ProductDetailsResponseEntity>());
        expect(result.status, isTrue);
        expect(result.message, 'Success');
        expect(result.code, 200);
        expect(result.errors, isEmpty);

        expect(result.data, isNotNull);
        expect(result.data!.id, '101');
        expect(result.data!.name, 'Pink Rose Bouquet');
      });

      test(
        'should keep data null when response data is null',
        () {
          // Arrange
          const response = ProductDetailsResponse(
            data: null,
            status: false,
            message: 'Failed',
            code: 400,
            errors: ['Error'],
          );

          // Act
          final result = mapper.mapProductDetailsResponse(response);

          // Assert
          expect(result.data, isNull);
          expect(result.status, isFalse);
          expect(result.message, 'Failed');
          expect(result.code, 400);
          expect(result.errors, hasLength(1));
        },
      );
    });

    group('mapProductsResponseToEntity', () {
      test('should map ProductsResponse to ProductsResponseEntity correctly', () {
        final response = ProductsResponse(
          status: true,
          data: ProductsDataDTO(
            items: [],
            pageNumber: 1,
            pageSize: 10,
            totalCount: 0,
            hasNextPage: false,
          ),
          errors: const [],
          code: 200,
          message: 'Success',
        );

        final result = mapper.mapProductsResponseToEntity(response);

        expect(result.status, true);
        expect(result.message, 'Success');
        expect(result.code, 200);
        expect(result.errors, isEmpty);
        expect(result.data, isNotNull);
      });

      test('should handle null values in ProductsResponse gracefully', () {
        final response = ProductsResponse(
          status: null,
          data: null,
          errors: null,
          code: null,
          message: null,
        );

        final result = mapper.mapProductsResponseToEntity(response);

        expect(result.status, false);
        expect(result.message, '');
        expect(result.code, isNull);
        expect(result.errors, isNull);
        expect(result.data, isNull);
      });
    });

    group('mapProductsDataToEntity', () {
      test('should map ProductsDataDTO to ProductsDataEntity correctly', () {
        final dto = ProductsDataDTO(
          items: [
            ProductItemDTO(
              id: '1',
              name: 'Item 1',
              imageUrl: 'image.jpg',
              originalPrice: 120.0,
              discountedPrice: 100.0,
              discountPercentage: 20,
              isOutOfStock: false,
            )
          ],
          pageNumber: 2,
          pageSize: 10,
          totalCount: 20,
          hasNextPage: false,
        );

        final result = mapper.mapProductsDataToEntity(dto);

        expect(result.items, hasLength(1));
        expect(result.items?.first.name, 'Item 1');
        expect(result.pagination?.page, 2);
        expect(result.pagination?.hasNextPage, false);
        expect(result.pagination?.hasPreviousPage, true);
        expect(result.pagination?.totalPages, 2);
      });

      test('should handle null items in ProductsDataDTO', () {
        final dto = ProductsDataDTO(
          items: null,
          pageNumber: null,
          pageSize: null,
          totalCount: null,
          hasNextPage: null,
        );

        final result = mapper.mapProductsDataToEntity(dto);

        expect(result.items, isEmpty);
        expect(result.pagination?.page, 1);
        expect(result.pagination?.pageSize, 0);
      });
    });

    group('mapProductItemToEntity', () {
      test('should map ProductItemDTO to ProductItemEntity correctly', () {
        final dto = ProductItemDTO(
          id: '42',
          name: 'Awesome Product',
          imageUrl: 'awesome.png',
          originalPrice: 129.99,
          discountedPrice: 99.99,
          discountPercentage: 30,
          isOutOfStock: false,
        );

        final result = mapper.mapProductItemToEntity(dto);

        expect(result.id, '42');
        expect(result.name, 'Awesome Product');
        expect(result.imageUrl, 'awesome.png');
        expect(result.currency, 'EGP');
        expect(result.price, 99.99);
        expect(result.originalPrice, 129.99);
        expect(result.discountPercentage, 30);
        expect(result.status, ProductStatus.inStock);
      });

      test('should handle null fields in ProductItemDTO', () {
        final dto = ProductItemDTO(
          id: null,
          name: 'Null Product',
          imageUrl: null,
          originalPrice: null,
          discountedPrice: null,
          discountPercentage: null,
          isOutOfStock: null,
        );

        final result = mapper.mapProductItemToEntity(dto);

        expect(result.id, isNull);
        expect(result.name, 'Null Product');
        expect(result.imageUrl, '');
        expect(result.currency, 'EGP');
        expect(result.price, isNull);
        expect(result.originalPrice, isNull);
        expect(result.discountPercentage, isNull);
        expect(result.status, ProductStatus.inStock);
      });

      test('should map isOutOfStock true to outOfStock status', () {
        final dto = ProductItemDTO(
          id: '1',
          name: 'Sold Out',
          isOutOfStock: true,
        );

        final result = mapper.mapProductItemToEntity(dto);

        expect(result.status, ProductStatus.outOfStock);
      });
    });

    group('mapPaginationToEntity', () {
      test('should map pagination fields from ProductsDataDTO correctly', () {
        final dto = ProductsDataDTO(
          pageNumber: 3,
          pageSize: 15,
          totalCount: 45,
          hasNextPage: false,
        );

        final result = mapper.mapPaginationToEntity(dto);

        expect(result.page, 3);
        expect(result.pageSize, 15);
        expect(result.totalCount, 45);
        expect(result.totalPages, 3);
        expect(result.hasNextPage, false);
        expect(result.hasPreviousPage, true);
      });

      test('should provide default values for missing pagination fields', () {
        final result = mapper.mapPaginationToEntity(ProductsDataDTO());

        expect(result.page, 1);
        expect(result.pageSize, 0);
        expect(result.totalCount, 0);
        expect(result.totalPages, 0);
        expect(result.hasNextPage, false);
        expect(result.hasPreviousPage, false);
      });
    });

    group('mapCategoriesResponseToEntity', () {
      test('should map CategoriesResponse to CategoriesResponseEntity correctly', () {
        final response = CategoriesResponse(
          status: true,
          data: [
            CategoryDTO(id: 'c1', name: 'Cat 1', iconUrl: 'icon.png'),
          ],
          errors: [],
          code: 200,
          message: 'Success',
        );

        final result = mapper.mapCategoriesResponseToEntity(response);

        expect(result.status, true);
        expect(result.data, hasLength(1));
        expect(result.data?.first.id, 'c1');
        expect(result.data?.first.name, 'Cat 1');
        expect(result.data?.first.iconName, 'icon.png');
        expect(result.message, 'Success');
      });

      test('should handle null values gracefully', () {
        final response = CategoriesResponse(
          status: null,
          data: null,
          errors: null,
          code: null,
          message: null,
        );

        final result = mapper.mapCategoriesResponseToEntity(response);

        expect(result.status, false);
        expect(result.data, isNull);
        expect(result.message, '');
      });
    });

    group('mapCategoryResponseToEntity', () {
      test('should map CategoryResponse to CategoryResponseEntity correctly', () {
        final response = CategoryResponse(
          status: true,
          data: CategoryDTO(id: 'c2', name: 'Cat 2', iconUrl: 'icon2.png'),
          errors: [],
          code: 200,
          message: 'Success',
        );

        final result = mapper.mapCategoryResponseToEntity(response);

        expect(result.status, true);
        expect(result.data, isNotNull);
        expect(result.data?.id, 'c2');
        expect(result.data?.name, 'Cat 2');
        expect(result.data?.iconName, 'icon2.png');
        expect(result.message, 'Success');
      });

      test('should handle null values gracefully', () {
        final response = CategoryResponse(
          status: null,
          data: null,
          errors: null,
          code: null,
          message: null,
        );

        final result = mapper.mapCategoryResponseToEntity(response);

        expect(result.status, false);
        expect(result.data, isNull);
        expect(result.message, '');
      });
    });

    group('mapCategoryToEntity', () {
      test('should map CategoryDTO to CategoryEntity correctly', () {
        final dto = CategoryDTO(id: 'c3', name: 'Cat 3', iconUrl: 'icon3.png');
        final result = mapper.mapCategoryToEntity(dto);

        expect(result.id, 'c3');
        expect(result.name, 'Cat 3');
        expect(result.iconName, 'icon3.png');
      });

      test('should handle null values gracefully', () {
        final dto = CategoryDTO(id: null, name: null, iconUrl: null);
        final result = mapper.mapCategoryToEntity(dto);

        expect(result.id, '');
        expect(result.name, '');
        expect(result.iconName, '');
      });
    });

    group('mapOccasionsResponseToEntity', () {
      test('should map OccasionsResponse to OccasionsResponseEntity correctly', () {
        final response = OccasionsResponse(
          status: true,
          data: [
            OccasionDTO(id: 'o1', name: 'Occasion 1', imageUrl: 'image.png'),
          ],
          errors: [],
          code: 200,
          message: 'Success',
        );

        final result = mapper.mapOccasionsResponseToEntity(response);

        expect(result.status, true);
        expect(result.data, hasLength(1));
        expect(result.data?.first.id, 'o1');
        expect(result.data?.first.name, 'Occasion 1');
        expect(result.data?.first.imageUrl, 'image.png');
        expect(result.message, 'Success');
      });

      test('should handle null values gracefully', () {
        final response = OccasionsResponse(
          status: null,
          data: null,
          errors: null,
          code: null,
          message: null,
        );

        final result = mapper.mapOccasionsResponseToEntity(response);

        expect(result.status, false);
        expect(result.data, isNull);
        expect(result.message, '');
      });
    });

    group('mapOccasionToEntity', () {
      test('should map OccasionDTO to OccasionEntity correctly', () {
        final dto = OccasionDTO(id: 'o2', name: 'Occasion 2', imageUrl: 'image2.png');
        final result = mapper.mapOccasionToEntity(dto);

        expect(result.id, 'o2');
        expect(result.name, 'Occasion 2');
        expect(result.imageUrl, 'image2.png');
      });

      test('should handle null values gracefully', () {
        final dto = OccasionDTO(id: null, name: null, imageUrl: null);
        final result = mapper.mapOccasionToEntity(dto);

        expect(result.id, '');
        expect(result.name, '');
        expect(result.imageUrl, '');
      });
    });
  });
}