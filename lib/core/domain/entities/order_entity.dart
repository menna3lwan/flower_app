import 'package:equatable/equatable.dart';

import 'cart_item_entity.dart';

enum OrderStatus { received, preparing, outForDelivery, delivered }

class OrderEntity extends Equatable {
  const OrderEntity({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.total,
    required this.status,
    required this.placedAt,
    this.deliveryPersonName,
  });

  final String id;
  final String orderNumber;
  final List<CartItemEntity> items;
  final double total;
  final OrderStatus status;
  final DateTime placedAt;
  final String? deliveryPersonName;

  bool get isActive => status != OrderStatus.delivered;

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        items,
        total,
        status,
        placedAt,
        deliveryPersonName,
      ];
}
