import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/core/usecase/usecase.dart';
import 'package:customer_app/features/commerce/domain/entities/category_entity.dart';
import 'package:customer_app/features/commerce/domain/repositories/catalog_repository.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_categories_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_best_sellers_use_case_test.mocks.dart';

@GenerateMocks([CatalogRepository])
void main() {
  late GetCategoriesUseCase useCase;
  late MockCatalogRepository mockCatalogRepository;

  setUp(() {
    provideDummy<Result<List<CategoryEntity>>>(const Result.success([]));
    mockCatalogRepository = MockCatalogRepository();
    useCase = GetCategoriesUseCase(mockCatalogRepository);
  });

  final categories = [
    const CategoryEntity(id: '1', name: 'Cat 1', iconName: 'icon1.png'),
    const CategoryEntity(id: '2', name: 'Cat 2', iconName: 'icon2.png'),
  ];

  test('should return list of categories from repository when successful', () async {
    // Arrange
    when(mockCatalogRepository.getCategories())
        .thenAnswer((_) async => Result.success(categories));

    // Act
    final result = await useCase(NoParams());

    // Assert
    expect(result, isA<Success<List<CategoryEntity>>>());
    result.fold(
      (_) => fail('Expected Success'),
      (data) {
        expect(data, categories);
      },
    );
    verify(mockCatalogRepository.getCategories()).called(1);
    verifyNoMoreInteractions(mockCatalogRepository);
  });

  test('should return failure from repository when unsuccessful', () async {
    // Arrange
    const failure = UnexpectedFailure();
    when(mockCatalogRepository.getCategories())
        .thenAnswer((_) async => const Result.failure(failure));

    // Act
    final result = await useCase(const NoParams());

    // Assert
    expect(result, isA<ResultFailure<List<CategoryEntity>>>());
    result.fold(
      (f) {
        expect(f, failure);
      },
      (_) => fail('Expected Failure'),
    );
    verify(mockCatalogRepository.getCategories()).called(1);
    verifyNoMoreInteractions(mockCatalogRepository);
  });
}
