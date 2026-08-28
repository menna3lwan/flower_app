import 'package:equatable/equatable.dart';
import '../../constants/enums/product_status.dart';

class ProductItemEntity extends Equatable {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? currency;
  final double? price;
  final double? originalPrice;
  final num? discountPercentage;
  final ProductStatus status;

  const ProductItemEntity({
    this.id,
    this.name,
    this.imageUrl,
    this.currency,
    this.price,
    this.originalPrice,
    this.discountPercentage,
    required this.status,
  });

  bool get hasDiscount =>
      originalPrice != null && price != null && originalPrice! > price!;

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    currency,
    price,
    originalPrice,
    discountPercentage,
    status,
  ];
}