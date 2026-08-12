import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/domain/entities/product_entity.dart';
import '../../core/extensions/string_extensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../extensions/localization_extensions.dart';
import 'media/app_image_placeholder.dart';

/// Product card shared across Best seller, Occasion, Categories and Search — depends only on [ProductEntity].
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: AppImagePlaceholder(borderRadius: BorderRadius.circular(AppDimens.radiusMedium)),
                ),
                if (product.discountPercentage != null)
                  // `PositionedDirectional` keeps the badge on the leading edge in both LTR and RTL.
                  PositionedDirectional(
                    top: AppDimens.space8,
                    start: AppDimens.space8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.space8,
                        vertical: AppDimens.space4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                      ),
                      child: Text(
                        '${product.discountPercentage}%',
                        style: AppTextStyles.caption.copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppDimens.space8),
            Text(
              product.name,
              style: AppTextStyles.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(product.price.asEgp, style: AppTextStyles.titleMedium),
                if (product.hasDiscount) ...[
                  const SizedBox(width: 6),
                  Text(
                    product.originalPrice!.asEgp,
                    style: AppTextStyles.bodySmall.copyWith(
                      decoration: TextDecoration.lineThrough,
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
                  label: Text(context.l10n.addToCart),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    textStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.onPrimary),
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
