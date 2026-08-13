import 'package:equatable/equatable.dart';

import './product_entity.dart';

/// A [ProductEntity] paired with a cart-specific quantity.
///
/// Wrapping rather than mutating the product keeps [ProductEntity]
/// immutable and free of cart concerns — the cart feature owns this
/// entity, the catalog features own [ProductEntity].
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
