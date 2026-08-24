import 'package:equatable/equatable.dart';

import './product_entity.dart';

/// [ProductEntity] + cart quantity, wrapping rather than mutating the product to keep it immutable.
class CartItemEntity extends Equatable {
  const CartItemEntity({
    required this.product,
    required this.quantity,
  });

  final ProductEntity product;
  final int quantity;

  double get subtotal => product.price * quantity;

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}
