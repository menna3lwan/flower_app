import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/core/usecase/usecase.dart';
import 'package:customer_app/features/commerce/domain/entities/occasion_entity.dart';
import 'package:customer_app/features/commerce/domain/repositories/catalog_repository.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_occasions_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_all_products_use_case_test.mocks.dart';


@GenerateMocks([CatalogRepository])
void main() {
  late GetOccasionsUseCase useCase;
  late MockCatalogRepository mockRepository;

  setUp(() {
    mockRepository = MockCatalogRepository();
    useCase = GetOccasionsUseCase(mockRepository);
    provideDummy<Result<List<OccasionEntity>>>(const Result.success([]));
  });

  const tOccasions = [
    OccasionEntity(id: '1', name: 'Occasion 1', imageUrl: 'url1'),
    OccasionEntity(id: '2', name: 'Occasion 2', imageUrl: 'url2'),
  ];

  test('should return list of occasions from repository correctly', () async {
    // Arrange
    when(mockRepository.getOccasions())
        .thenAnswer((_) async => const Result.success(tOccasions));

    // Act
    final result = await useCase(const NoParams());

    // Assert
    expect(result, isA<Success<List<OccasionEntity>>>());
    result.fold(
      (_) => fail('Expected success'),
      (data) => expect(data, tOccasions),
    );
    verify(mockRepository.getOccasions());
    verifyNoMoreInteractions(mockRepository);
  });
}
