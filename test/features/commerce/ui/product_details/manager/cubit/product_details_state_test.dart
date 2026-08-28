import 'package:customer_app/core/base/operation_state.dart';
import 'package:customer_app/features/commerce/constants/enums/product_status.dart';
import 'package:customer_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:customer_app/features/commerce/ui/product_details/manager/cubit/product_details_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductDetailsState', () {
    const tProductDetails = ProductDetailsEntity(
      id: '123',
      name: 'Test Product',
      status: ProductStatus.inStock,
    );

    test('supports value equality', () {
      expect(
        const ProductDetailsState(operationState: OperationState()),
        const ProductDetailsState(operationState: OperationState()),
      );
    });

    test('copyWith returns a new instance with the same values if no parameters are provided', () {
      const state = ProductDetailsState(operationState: OperationState());
      final result = state.copyWith();

      expect(result, state);
    });

    test('copyWith returns a new instance with updated values', () {
      const state = ProductDetailsState(operationState: OperationState());
      final newOperationState = const OperationState<ProductDetailsEntity>().success(tProductDetails);
      
      final result = state.copyWith(operationState: newOperationState);

      expect(result.operationState, newOperationState);
      expect(result, isNot(state));
    });
  });
}
