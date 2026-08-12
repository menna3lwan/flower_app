import 'package:flutter/material.dart';

import 'package:design_system/constants/app_colors.dart';
import 'package:design_system/constants/app_dimens.dart';
import '../../constants/app_strings.dart';
import '../../core/domain/entities/product_entity.dart';
import 'package:core/extensions/string_extensions.dart';
import 'package:design_system/theme/app_text_styles.dart';
import 'package:common/widgets/media/app_image_placeholder.dart';

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
                  Positioned(
                    top: AppDimens.space8,
                    left: AppDimens.space8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                      ),
                      child: Text(
                        '${product.discountPercentage}%',
                        style: AppTextStyles.caption.copyWith(color: AppColors.white, fontSize: 11),
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
                  label: Text(AppStrings.addToCart),
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
