import 'package:equatable/equatable.dart';

/// Core product entity — the shared domain representation of a flower
/// product across the home, catalog, product-details, cart and orders
/// features.
///
/// This lives in `core/domain` (a "shared kernel") rather than inside a
/// single feature because five different features legitimately need the
/// same concept; duplicating it per-feature would violate DRY and Single
/// Source of Truth. Feature-specific data (e.g. a cart quantity) is
/// modeled as a separate entity that *wraps* this one — see
/// [CartItemEntity] — rather than mutating this entity.
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
