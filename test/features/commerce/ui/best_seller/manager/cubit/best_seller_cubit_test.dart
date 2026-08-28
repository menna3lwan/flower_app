import 'package:bloc_test/bloc_test.dart';
import 'package:customer_app/core/base/operation_state.dart';
import 'package:customer_app/core/base/pagination_params.dart';
import 'package:customer_app/core/base/pagination_state.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/features/commerce/constants/enums/product_status.dart';
import 'package:customer_app/features/commerce/domain/entities/pagination_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/product_item_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/products_data_entity.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_best_sellers_use_case.dart';
import 'package:customer_app/features/commerce/ui/best_seller/manager/cubit/best_seller_cubit.dart';
import 'package:customer_app/features/commerce/ui/best_seller/manager/cubit/best_seller_state.dart';
import 'package:customer_app/features/commerce/ui/best_seller/manager/cubit/best_selleter_intent.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'best_seller_cubit_test.mocks.dart';

@GenerateMocks([GetBestSellersUseCase])
void main() {
  late MockGetBestSellersUseCase mockGetBestSellersUseCase;
  late BestSellerCubit cubit;

  const tProduct1 = ProductItemEntity(
    id: 'p1',
    name: 'Best Seller 1',
    imageUrl: 'url1',
    price: 20,
    currency: 'EGP',
    status: ProductStatus.inStock,
  );
  const tProduct2 = ProductItemEntity(
    id: 'p2',
    name: 'Best Seller 2',
    imageUrl: 'url2',
    price: 30,
    currency: 'EGP',
    status: ProductStatus.inStock,
  );
  const tPaginationWithNext = PaginationEntity(
    page: 1,
    pageSize: 10,
    totalCount: 20,
    totalPages: 2,
    hasNextPage: true,
    hasPreviousPage: false,
  );
  const tPaginationLastPage = PaginationEntity(
    page: 2,
    pageSize: 10,
    totalCount: 20,
    totalPages: 2,
    hasNextPage: false,
    hasPreviousPage: true,
  );
  const tProductsData = ProductsDataEntity(
    items: [tProduct1],
    pagination: tPaginationWithNext,
  );
  const tSuccessState = BestSellerState(
    operationState: PaginationState(
      status: OperationStatus.success,
      items: [tProduct1],
    ),
  );

  setUp(() {
    provideDummy<Result<ProductsDataEntity>>(const Success(tProductsData));
    mockGetBestSellersUseCase = MockGetBestSellersUseCase();
    cubit = BestSellerCubit(mockGetBestSellersUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('BestSellerCubit', () {
    test('initial state should be BestSellerState with idle PaginationState', () {
      expect(
        cubit.state,
        const BestSellerState(operationState: PaginationState()),
      );
    });

    blocTest<BestSellerCubit, BestSellerState>(
      'emits [loading, success] when GetBestSellerIntent succeeds',
      build: () {
        when(mockGetBestSellersUseCase(const PaginationParams(page: 1)))
            .thenAnswer((_) async => const Success(tProductsData));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetBestSellerIntent()),
      expect: () => [
        const BestSellerState(
          operationState: PaginationState(status: OperationStatus.loading),
        ),
        const BestSellerState(
          operationState: PaginationState(
            status: OperationStatus.success,
            items: [tProduct1],
            hasReachedMax: false,
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetBestSellersUseCase(const PaginationParams(page: 1))).called(1);
      },
    );

    blocTest<BestSellerCubit, BestSellerState>(
      'emits success with empty items and hasReachedMax when data and pagination are null',
      build: () {
        when(mockGetBestSellersUseCase(const PaginationParams(page: 1)))
            .thenAnswer((_) async => const Success(ProductsDataEntity()));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetBestSellerIntent()),
      expect: () => [
        const BestSellerState(
          operationState: PaginationState(status: OperationStatus.loading),
        ),
        const BestSellerState(
          operationState: PaginationState(
            status: OperationStatus.success,
            items: [],
            hasReachedMax: true,
          ),
        ),
      ],
    );

    blocTest<BestSellerCubit, BestSellerState>(
      'emits [loading, failure] when GetBestSellerIntent fails',
      build: () {
        const tFailure = ServerFailure('Server Error');
        when(mockGetBestSellersUseCase(const PaginationParams(page: 1)))
            .thenAnswer((_) async => const ResultFailure(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetBestSellerIntent()),
      expect: () => [
        const BestSellerState(
          operationState: PaginationState(status: OperationStatus.loading),
        ),
        const BestSellerState(
          operationState: PaginationState(
            status: OperationStatus.failure,
            error: ServerFailure('Server Error'),
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetBestSellersUseCase(const PaginationParams(page: 1))).called(1);
      },
    );

    blocTest<BestSellerCubit, BestSellerState>(
      'emits [fetchingMore, fetchMoreSuccess] when LoadMoreBestSellerIntent succeeds',
      build: () {
        when(mockGetBestSellersUseCase(const PaginationParams(page: 2)))
            .thenAnswer(
          (_) async => const Success(
            ProductsDataEntity(
              items: [tProduct2],
              pagination: tPaginationLastPage,
            ),
          ),
        );
        return cubit;
      },
      seed: () => tSuccessState,
      act: (cubit) => cubit.doIntent(LoadMoreBestSellerIntent()),
      expect: () => [
        const BestSellerState(
          operationState: PaginationState(
            status: OperationStatus.success,
            items: [tProduct1],
            isFetchingMore: true,
          ),
        ),
        const BestSellerState(
          operationState: PaginationState(
            status: OperationStatus.success,
            items: [tProduct1, tProduct2],
            hasReachedMax: true,
            currentPage: 2,
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetBestSellersUseCase(const PaginationParams(page: 2))).called(1);
      },
    );

    blocTest<BestSellerCubit, BestSellerState>(
      'emits [fetchingMore, fetchMoreFailed] when LoadMoreBestSellerIntent fails',
      build: () {
        const tFailure = NetworkFailure();
        when(mockGetBestSellersUseCase(const PaginationParams(page: 2)))
            .thenAnswer((_) async => const ResultFailure(tFailure));
        return cubit;
      },
      seed: () => tSuccessState,
      act: (cubit) => cubit.doIntent(LoadMoreBestSellerIntent()),
      expect: () => [
        const BestSellerState(
          operationState: PaginationState(
            status: OperationStatus.success,
            items: [tProduct1],
            isFetchingMore: true,
          ),
        ),
        const BestSellerState(
          operationState: PaginationState(
            status: OperationStatus.success,
            items: [tProduct1],
            fetchMoreError: NetworkFailure(),
          ),
        ),
      ],
    );

    blocTest<BestSellerCubit, BestSellerState>(
      'does not emit when LoadMoreBestSellerIntent is called after last page',
      build: () => cubit,
      seed: () => const BestSellerState(
        operationState: PaginationState(
          status: OperationStatus.success,
          items: [tProduct1],
          hasReachedMax: true,
        ),
      ),
      act: (cubit) => cubit.doIntent(LoadMoreBestSellerIntent()),
      expect: () => <BestSellerState>[],
      verify: (_) {
        verifyNever(mockGetBestSellersUseCase(any));
      },
    );

    blocTest<BestSellerCubit, BestSellerState>(
      'does not emit when LoadMoreBestSellerIntent is called while fetching more',
      build: () => cubit,
      seed: () => const BestSellerState(
        operationState: PaginationState(
          status: OperationStatus.success,
          items: [tProduct1],
          isFetchingMore: true,
        ),
      ),
      act: (cubit) => cubit.doIntent(LoadMoreBestSellerIntent()),
      expect: () => <BestSellerState>[],
      verify: (_) {
        verifyNever(mockGetBestSellersUseCase(any));
      },
    );

    blocTest<BestSellerCubit, BestSellerState>(
      'does not emit when LoadMoreBestSellerIntent is called while loading',
      build: () => cubit,
      seed: () => const BestSellerState(
        operationState: PaginationState(status: OperationStatus.loading),
      ),
      act: (cubit) => cubit.doIntent(LoadMoreBestSellerIntent()),
      expect: () => <BestSellerState>[],
      verify: (_) {
        verifyNever(mockGetBestSellersUseCase(any));
      },
    );
  });
}
