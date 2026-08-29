import 'package:equatable/equatable.dart';

import '../../constants/enums/product_status.dart';
import 'includes_entity.dart';

class ProductDetailsEntity extends Equatable {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? currency;
  final double? price;
  final double? originalPrice;
  final num? discountPercentage;
  final ProductStatus status;
  final List<String>? images;
  final String? description;
  final List<IncludesEntity>? includes;
  final int? stockQuantity;
  final String? categoryId;

  final List<String>? occasionIds;

  bool get hasDiscount =>
      originalPrice != null && price != null && originalPrice! > price!;

  const ProductDetailsEntity({
    this.id,
    this.name,
    this.imageUrl,
    this.currency,
    this.price,
    this.originalPrice,
    this.discountPercentage,
    required this.status,
    this.images,
    this.description,
    this.includes,
    this.categoryId,
    this.occasionIds,
    this.stockQuantity,
  });

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
        images,
        description,
        includes,
        categoryId,
        occasionIds,
        stockQuantity,
      ];
}
