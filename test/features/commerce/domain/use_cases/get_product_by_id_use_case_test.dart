import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/features/commerce/constants/enums/product_status.dart';
import 'package:customer_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:customer_app/features/commerce/domain/repositories/catalog_repository.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_product_by_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_product_by_id_use_case_test.mocks.dart';

@GenerateMocks([CatalogRepository])
void main() {
  late GetProductByIdUseCase useCase;
  late MockCatalogRepository mockCatalogRepository;

  const tProductId = '123';
  const tProductDetails = ProductDetailsEntity(
    id: tProductId,
    name: 'Test Product',
    status: ProductStatus.inStock,
  );

  setUp(() {
    provideDummy<Result<ProductDetailsEntity>>(const Success(tProductDetails));
    mockCatalogRepository = MockCatalogRepository();
    useCase = GetProductByIdUseCase(mockCatalogRepository);
  });

  test('should get product details from the repository', () async {
    // arrange
    when(mockCatalogRepository.getProductById(tProductId))
        .thenAnswer((_) async => const Success(tProductDetails));
    
    // act
    final result = await useCase(tProductId);
    
    // assert
    expect(result, isA<Success<ProductDetailsEntity>>());
    result.fold(
      (failure) => fail('Expected Success'),
      (data) => expect(data, tProductDetails),
    );
    verify(mockCatalogRepository.getProductById(tProductId));
    verifyNoMoreInteractions(mockCatalogRepository);
  });

  test('should return failure when the repository call fails', () async {
    // arrange
    const tFailure = NotFoundFailure('Product not found');
    when(mockCatalogRepository.getProductById(tProductId))
        .thenAnswer((_) async => const ResultFailure(tFailure));
    
    // act
    final result = await useCase(tProductId);
    
    // assert
    expect(result, isA<ResultFailure<ProductDetailsEntity>>());
    result.fold(
      (failure) => expect(failure, tFailure),
      (data) => fail('Expected Failure'),
    );
    verify(mockCatalogRepository.getProductById(tProductId));
    verifyNoMoreInteractions(mockCatalogRepository);
  });
}
