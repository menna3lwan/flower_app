import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import '../../core/domain/entities/product_entity.dart';
import 'package:customer_app/core/extensions/string_extensions.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';
import 'package:customer_app/common/widgets/media/app_image_placeholder.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.width,
    super.key,
  });

  final ProductEntity product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final double? width;

  /// Home compact preview (Figma best-seller / carousel) — no add-to-cart.
  bool get _isCompact => onAddToCart == null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: _isCompact
                      ? AppDimens.homeCardWidth /
                          AppDimens.productCardImageHeight
                      : 1,
                  child: AppImagePlaceholder(
                    borderRadius: _isCompact
                        ? BorderRadius.zero
                        : BorderRadius.circular(AppDimens.radiusMedium),
                  ),
                ),
                if (product.discountPercentage != null)
                  PositionedDirectional(
                    top: AppDimens.space8,
                    start: AppDimens.space8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.space8,
                          vertical: AppDimens.space4),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusSmall),
                      ),
                      child: Text(
                        '${product.discountPercentage}%',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.white, fontSize: 11),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppDimens.space8),
            Text(
              product.name,
              style: _isCompact
                  ? AppTextStyles.productCardTitle
                  : AppTextStyles.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: _isCompact ? AppDimens.space4 : 2),
            Row(
              children: [
                Flexible(
                  child: Text(
                    product.price.asEgp,
                    style: _isCompact
                        ? AppTextStyles.productCardPrice
                        : AppTextStyles.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (product.hasDiscount) ...[
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      product.originalPrice!.asEgp,
                      style: AppTextStyles.bodySmall.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            if (onAddToCart != null) ...[
              const SizedBox(height: AppDimens.space8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onAddToCart,
                  icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                  label: Text(AppStrings.addToCart),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    textStyle: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.onPrimary),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
