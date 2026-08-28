import 'package:customer_app/core/base/pagination_state.dart';
import 'package:customer_app/features/commerce/constants/enums/product_status.dart';
import 'package:customer_app/features/commerce/domain/entities/product_item_entity.dart';
import 'package:customer_app/features/commerce/ui/best_seller/manager/cubit/best_seller_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BestSellerState', () {
    const tProduct = ProductItemEntity(
      id: 'p1',
      name: 'Best Seller',
      status: ProductStatus.inStock,
    );

    test('supports value equality', () {
      expect(
        const BestSellerState(operationState: PaginationState()),
        const BestSellerState(operationState: PaginationState()),
      );
    });

    test('copyWith returns a new instance with the same values if no parameters are provided', () {
      const state = BestSellerState(operationState: PaginationState());
      final result = state.copyWith();

      expect(result, state);
    });

    test('copyWith returns a new instance with updated values', () {
      const state = BestSellerState(operationState: PaginationState());
      final newOperationState = const PaginationState<ProductItemEntity>().success(
        [tProduct],
        hasReachedMax: true,
      );

      final result = state.copyWith(operationState: newOperationState);

      expect(result.operationState, newOperationState);
      expect(result, isNot(state));
    });
  });
}
