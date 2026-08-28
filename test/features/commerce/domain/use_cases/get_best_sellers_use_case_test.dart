import 'package:customer_app/core/base/pagination_params.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/features/commerce/constants/enums/product_status.dart';
import 'package:customer_app/features/commerce/domain/entities/pagination_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/product_item_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/products_data_entity.dart';
import 'package:customer_app/features/commerce/domain/repositories/catalog_repository.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_best_sellers_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'get_best_sellers_use_case_test.mocks.dart';

@GenerateMocks([CatalogRepository])
void main() {
  late GetBestSellersUseCase useCase;
  late MockCatalogRepository mockCatalogRepository;

  const tParams = PaginationParams(page: 1, pageSize: 10);
  const tProductsData = ProductsDataEntity(
    items: [
      ProductItemEntity(
        id: 'p1',
        name: 'Best Seller',
        imageUrl: 'url',
        price: 20,
        currency: 'EGP',
        originalPrice: 25,
        discountPercentage: 20,
        status: ProductStatus.inStock,
      ),
    ],
    pagination: PaginationEntity(
      page: 1,
      pageSize: 10,
      totalCount: 1,
      totalPages: 1,
      hasNextPage: false,
      hasPreviousPage: false,
    ),
  );

  setUp(() {
    provideDummy<Result<ProductsDataEntity>>(const Success(tProductsData));
    mockCatalogRepository = MockCatalogRepository();
    useCase = GetBestSellersUseCase(mockCatalogRepository);
  });

  test('should get best sellers from the repository', () async {
    when(mockCatalogRepository.getBestSellers(tParams))
        .thenAnswer((_) async => const Success(tProductsData));

    final result = await useCase(tParams);

    expect(result, isA<Success<ProductsDataEntity>>());
    result.fold(
      (failure) => fail('Expected Success'),
      (data) => expect(data, tProductsData),
    );
    verify(mockCatalogRepository.getBestSellers(tParams));
    verifyNoMoreInteractions(mockCatalogRepository);
  });

  test('should return failure when the repository call fails', () async {
    const tFailure = NetworkFailure();
    when(mockCatalogRepository.getBestSellers(tParams))
        .thenAnswer((_) async => const ResultFailure(tFailure));

    final result = await useCase(tParams);

    expect(result, isA<ResultFailure<ProductsDataEntity>>());
    result.fold(
      (failure) => expect(failure, tFailure),
      (data) => fail('Expected Failure'),
    );
    verify(mockCatalogRepository.getBestSellers(tParams));
    verifyNoMoreInteractions(mockCatalogRepository);
  });
}
