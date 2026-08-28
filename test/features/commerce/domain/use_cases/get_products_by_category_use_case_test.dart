import 'package:customer_app/core/base/pagination_params.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/core/usecase/usecase.dart';
import 'package:customer_app/features/commerce/domain/entities/pagination_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/products_data_entity.dart';
import 'package:customer_app/features/commerce/domain/repositories/catalog_repository.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_products_by_category_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_best_sellers_use_case_test.mocks.dart';

@GenerateMocks([CatalogRepository])
void main() {
  late GetProductsByCategoryUseCase useCase;
  late MockCatalogRepository mockRepository;

  setUp(() {
    mockRepository = MockCatalogRepository();
    useCase = GetProductsByCategoryUseCase(mockRepository);
    provideDummy<Result<ProductsDataEntity>>(const Result.success(ProductsDataEntity(items: [], pagination: PaginationEntity(page: 1, pageSize: 1, totalCount: 1, totalPages: 1, hasNextPage: false, hasPreviousPage: false))));
  });

  const tProductsDataEntity = ProductsDataEntity(
    items: [],
    pagination: PaginationEntity(
      page: 1,
      pageSize: 10,
      totalCount: 0,
      totalPages: 1,
      hasNextPage: false,
      hasPreviousPage: false,
    ),
  );

  const tCategoryId = 'cat_1';
  const tPaginationParams = PaginationParams(page: 1, pageSize: 10);
  const tParams = ParamsWithPagination<String>(param: tCategoryId, pagination: tPaginationParams);

  test('should return products from repository correctly', () async {
    // Arrange
    when(mockRepository.getProductsByCategory(tPaginationParams, tCategoryId))
        .thenAnswer((_) async => const Result.success(tProductsDataEntity));

    // Act
    final result = await useCase(tParams);

    // Assert
    expect(result, isA<Success<ProductsDataEntity>>());
    result.fold(
      (_) => fail('Expected success'),
      (data) => expect(data, tProductsDataEntity),
    );
    verify(mockRepository.getProductsByCategory(tPaginationParams, tCategoryId));
    verifyNoMoreInteractions(mockRepository);
  });
}
