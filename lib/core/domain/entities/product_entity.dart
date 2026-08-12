import 'package:equatable/equatable.dart';

/// Shared-kernel product entity used across home, catalog, product-details, cart and orders features.
class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    this.rating = 0,
    this.categoryId,
    this.description,
    this.includes = const [],
    this.gallery = const [],
    this.inStock = true,
  });

  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final int? discountPercentage;
  final double rating;
  final String? categoryId;
  final String? description;
  final List<String> includes;
  final List<String> gallery;
  final bool inStock;

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        price,
        originalPrice,
        discountPercentage,
        rating,
        categoryId,
        description,
        includes,
        gallery,
        inStock,
      ];
}
