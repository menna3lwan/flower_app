import 'package:bloc_test/bloc_test.dart';
import 'package:customer_app/core/base/operation_state.dart';
import 'package:customer_app/core/base/pagination_state.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/features/commerce/domain/entities/occasion_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/pagination_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/products_data_entity.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_occasions_use_case.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_products_by_occasion_use_case.dart';
import 'package:customer_app/features/commerce/ui/occasions/manager/cubit/occasions_cubit.dart';
import 'package:customer_app/features/commerce/ui/occasions/manager/cubit/occasions_intent.dart';
import 'package:customer_app/features/commerce/ui/occasions/manager/cubit/occasions_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'occasions_cubit_test.mocks.dart';

@GenerateMocks([
  GetProductsByOccasionUseCase,
  GetOccasionsUseCase,
])
void main() {
  late OccasionsCubit cubit;
  late MockGetProductsByOccasionUseCase mockGetProductsUseCase;
  late MockGetOccasionsUseCase mockGetOccasionsUseCase;

  setUp(() {
    mockGetProductsUseCase = MockGetProductsByOccasionUseCase();
    mockGetOccasionsUseCase = MockGetOccasionsUseCase();
    cubit = OccasionsCubit(mockGetProductsUseCase, mockGetOccasionsUseCase);
    
    provideDummy<Result<List<OccasionEntity>>>(const Result.success([]));
    provideDummy<Result<ProductsDataEntity>>(const Result.success(ProductsDataEntity(items: [], pagination: PaginationEntity(page: 1, pageSize: 1, totalCount: 1, totalPages: 1, hasNextPage: false, hasPreviousPage: false))));
  });

  tearDown(() {
    cubit.close();
  });

  const tOccasions = [
    OccasionEntity(id: '1', name: 'Occasion 1', imageUrl: 'url1'),
  ];

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

  group('OccasionsCubit', () {
    test('initial state should be empty', () {
      expect(
        cubit.state,
        const OccasionsState(
          productsByOccasionIdState: PaginationState(),
          occasionsState: OperationState(),
        ),
      );
    });

    blocTest<OccasionsCubit, OccasionsState>(
      'emits loading and success when GetOccasionsIntent is successful',
      build: () {
        when(mockGetOccasionsUseCase.call(any))
            .thenAnswer((_) async => const Result.success(tOccasions));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetOccasionsIntent()),
      expect: () => [
        cubit.state.copyWith(occasionsState: const OperationState(status: OperationStatus.loading)),
        cubit.state.copyWith(occasionsState: const OperationState(status: OperationStatus.success, data: tOccasions)),
      ],
      verify: (_) {
        verify(mockGetOccasionsUseCase.call(any)).called(1);
      },
    );

    blocTest<OccasionsCubit, OccasionsState>(
      'emits loading and failed when GetOccasionsIntent fails',
      build: () {
        when(mockGetOccasionsUseCase.call(any))
            .thenAnswer((_) async => Result.failure(const ServerFailure('Error')));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetOccasionsIntent()),
      expect: () => [
        cubit.state.copyWith(occasionsState: const OperationState(status: OperationStatus.loading)),
        cubit.state.copyWith(occasionsState: const OperationState(status: OperationStatus.failure, failure: ServerFailure('Error'))),
      ],
    );

    blocTest<OccasionsCubit, OccasionsState>(
      'emits loading and success when GetProductsByOccasionIdIntent is successful',
      build: () {
        when(mockGetProductsUseCase.call(any))
            .thenAnswer((_) async => const Result.success(tProductsDataEntity));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetProductsByOccasionIdIntent('occ_1')),
      expect: () => [
        cubit.state.copyWith(productsByOccasionIdState: const PaginationState(status: OperationStatus.loading)),
        cubit.state.copyWith(productsByOccasionIdState: const PaginationState(status: OperationStatus.success, items: [], hasReachedMax: true)),
      ],
    );

    blocTest<OccasionsCubit, OccasionsState>(
      'emits loading and failed when GetProductsByOccasionIdIntent fails',
      build: () {
        when(mockGetProductsUseCase.call(any))
            .thenAnswer((_) async => const Result.failure(ServerFailure('Failed')));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetProductsByOccasionIdIntent('occ_1')),
      expect: () => [
        cubit.state.copyWith(productsByOccasionIdState: const PaginationState(status: OperationStatus.loading)),
        cubit.state.copyWith(productsByOccasionIdState: const PaginationState(status: OperationStatus.failure, error: ServerFailure('Failed'))),
      ],
    );
  });
}
