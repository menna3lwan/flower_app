import '../../features/commerce/domain/entities/product_details_entity.dart';
import '../../features/commerce/domain/entities/product_item_entity.dart';

/// String helpers shared across features (formatting, capitalization).
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  bool get isBlank => trim().isEmpty;
}

/// Currency formatting for the app's one supported currency (EGP).
extension PriceFormatting on num {
  String get asEgp => 'EGP ${toStringAsFixed(0)}';
}

/// Nullable variant so `price?.asEgp` call sites don't need extra null handling.
extension PriceFormattingNullable on num? {
  String get asEgp => this == null ? '—' : this!.asEgp;
}

extension ProductDetailsDiscountX on ProductDetailsEntity {
  /// Safely calculates or returns the discount percentage.
  /// Prevents NullPointerException and Division-by-Zero errors.
  num get safeDiscountPercentage {
    if (!hasDiscount) return 0;
    if (discountPercentage != null) return discountPercentage!;

    final orig = originalPrice;
    final pr = price;

    if (orig == null || pr == null || orig == 0) return 0;

    return (((orig - pr) / orig) * 100).round();
  }
}

extension ProductDiscountX on ProductItemEntity {
  /// Safely calculates or returns the discount percentage.
  /// Prevents NullPointerException and Division-by-Zero errors.
  num get safeDiscountPercentage {
    if (!hasDiscount) return 0;
    if (discountPercentage != null) return discountPercentage!;

    final orig = originalPrice;
    final pr = price;

    if (orig == null || pr == null || orig == 0) return 0;

    return (((orig - pr) / orig) * 100).round();
  }
}