import 'package:flutter/material.dart';
import '../../../../common/widgets/media/app_image_placeholder.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../constants/enums/product_status.dart';
import '../../domain/entities/product_item_entity.dart';


class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.width,
    super.key,
  });

  final ProductItemEntity product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final num calculatedDiscount = product.safeDiscountPercentage;


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
                  child: AppImagePlaceholder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusMedium)),
                ),

                Positioned(
                  top: AppDimens.space8,
                  left: AppDimens.space8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.status == ProductStatus.inStock
                          ? AppColors.success
                          : AppColors.error,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusSmall),
                    ),
                    child: Text(
                      product.status == ProductStatus.inStock
                          ? AppStrings.inStock
                          : AppStrings.outOfStock,
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.white, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.space8),
            Text(
              product.name ?? AppStrings.noTitle,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(product.price.asEgp, style: AppTextStyles.bodyMedium),
                if (product.hasDiscount) ...[
                  const SizedBox(width: 6),
                  Text(
                    product.originalPrice!.toStringAsFixed(0),
                    style: AppTextStyles.bodySmall.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    '${product.discountPercentage ?? calculatedDiscount}%',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
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
