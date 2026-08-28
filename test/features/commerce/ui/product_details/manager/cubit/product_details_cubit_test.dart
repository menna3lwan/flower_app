import 'package:customer_app/core/base/operation_state.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/features/commerce/constants/enums/product_status.dart';
import 'package:customer_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_product_by_id_use_case.dart';
import 'package:customer_app/features/commerce/ui/product_details/manager/cubit/product_details_cubit.dart';
import 'package:customer_app/features/commerce/ui/product_details/manager/cubit/product_details_intent.dart';
import 'package:customer_app/features/commerce/ui/product_details/manager/cubit/product_details_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'product_details_cubit_test.mocks.dart';

@GenerateMocks([GetProductByIdUseCase])
void main() {
  late MockGetProductByIdUseCase mockGetProductByIdUseCase;
  late ProductDetailsCubit cubit;

  const tProductId = '123';
  const tProductDetails = ProductDetailsEntity(
    id: tProductId,
    name: 'Test Product',
    status: ProductStatus.inStock,
  );

  setUp(() {
    provideDummy<Result<ProductDetailsEntity>>(const Success(tProductDetails));
    mockGetProductByIdUseCase = MockGetProductByIdUseCase();
    cubit = ProductDetailsCubit(mockGetProductByIdUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('ProductDetailsCubit', () {
    test('initial state should be ProductDetailsState with idle operationState', () {
      expect(
        cubit.state,
        const ProductDetailsState(operationState: OperationState()),
      );
    });

    blocTest<ProductDetailsCubit, ProductDetailsState>(
      'emits [loading, success] when GetProductByIdIntent is executed successfully',
      build: () {
        when(mockGetProductByIdUseCase(tProductId))
            .thenAnswer((_) async => const Success(tProductDetails));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetProductByIdIntent(tProductId)),
      expect: () => [
        const ProductDetailsState(
          operationState: OperationState<ProductDetailsEntity>(status: OperationStatus.loading),
        ),
        const ProductDetailsState(
          operationState: OperationState<ProductDetailsEntity>(
            status: OperationStatus.success,
            data: tProductDetails,
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetProductByIdUseCase(tProductId)).called(1);
      },
    );

    blocTest<ProductDetailsCubit, ProductDetailsState>(
      'emits [loading, failure] when GetProductByIdIntent fails',
      build: () {
        const tFailure = ServerFailure('Server Error');
        when(mockGetProductByIdUseCase(tProductId))
            .thenAnswer((_) async => const ResultFailure(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetProductByIdIntent(tProductId)),
      expect: () => [
        const ProductDetailsState(
          operationState: OperationState<ProductDetailsEntity>(status: OperationStatus.loading),
        ),
        const ProductDetailsState(
          operationState: OperationState<ProductDetailsEntity>(
            status: OperationStatus.failure,
            failure: ServerFailure('Server Error'),
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetProductByIdUseCase(tProductId)).called(1);
      },
    );
  });
}
