import 'package:bloc_test/bloc_test.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/features/commerce/domain/entities/category_entity.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_categories_use_case.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_products_by_category_use_case.dart';
import 'package:customer_app/features/commerce/ui/categories/manager/cubit/categories_cubit.dart';
import 'package:customer_app/features/commerce/ui/categories/manager/cubit/categories_intent.dart';
import 'package:customer_app/features/commerce/ui/categories/manager/cubit/categories_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'categories_cubit_test.mocks.dart';

@GenerateMocks([GetCategoriesUseCase, GetProductsByCategoryUseCase])
void main() {
  late CategoriesCubit cubit;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetProductsByCategoryUseCase mockGetProductsByCategoryUseCase;

  setUp(() {
    provideDummy<Result<List<CategoryEntity>>>(const Result.success([]));
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockGetProductsByCategoryUseCase = MockGetProductsByCategoryUseCase();
    cubit = CategoriesCubit(
      mockGetProductsByCategoryUseCase,
      mockGetCategoriesUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('CategoriesCubit - GetCategoriesIntent', () {
    final categories = [
      const CategoryEntity(id: 'c1', name: 'Cat 1', iconName: 'icon1'),
      const CategoryEntity(id: 'c2', name: 'Cat 2', iconName: 'icon2'),
    ];

    test('initial state should be empty', () {
      expect(cubit.state.categoriesState.isIdle, isTrue);
    });

    blocTest<CategoriesCubit, CategoriesState>(
      'emits [loading, success] when getCategories succeeds',
      build: () {
        when(mockGetCategoriesUseCase(any))
            .thenAnswer((_) async => Result.success(categories));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetCategoriesIntent()),
      expect: () => [
        isA<CategoriesState>().having(
                (s) => s.categoriesState.isLoading, 'isLoading', isTrue),
        isA<CategoriesState>()
            .having((s) => s.categoriesState.isSuccess, 'isSuccess', isTrue)
            .having((s) => s.categoriesState.data, 'data', categories),
      ],
      verify: (_) {
        verify(mockGetCategoriesUseCase(any)).called(1);
      },
    );

    blocTest<CategoriesCubit, CategoriesState>(
      'emits [loading, failure] when getCategories fails',
      build: () {
        when(mockGetCategoriesUseCase(any))
            .thenAnswer((_) async => Result.failure(const UnexpectedFailure()));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetCategoriesIntent()),
      expect: () => [
        isA<CategoriesState>().having(
                (s) => s.categoriesState.isLoading, 'isLoading', isTrue),
        isA<CategoriesState>()
            .having((s) => s.categoriesState.isFailure, 'isFailure', isTrue)
            .having(
                (s) => s.categoriesState.failure, 'failure', isA<UnexpectedFailure>()),
      ],
      verify: (_) {
        verify(mockGetCategoriesUseCase(any)).called(1);
      },
    );
  });
}