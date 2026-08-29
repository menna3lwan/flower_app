import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimens.dart';
import '../../../../../core/extensions/string_extensions.dart';
import '../../../../../core/localization/app_strings.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/product_details_entity.dart';

class ProductDetailsContent extends StatelessWidget {
  const ProductDetailsContent({
    super.key,
    required this.product,
  });

  final ProductDetailsEntity product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceAndStatus(),
          const Gap(AppDimens.space4),
          _buildTaxText(),
          const Gap(AppDimens.space8),
          _buildProductName(),
          const Gap(AppDimens.space20),
          _buildDescription(),
          const Gap(AppDimens.space24),
          _buildIncludes(),
        ],
      ),
    );
  }

  Widget _buildPriceAndStatus() {
    final num calculatedDiscount = product.safeDiscountPercentage;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              product.price?.asEgp ?? '',
              style: AppTextStyles.appBarTitleEmphasis.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (product.hasDiscount) ...[
              const Gap(AppDimens.space8),
              if (product.originalPrice != null)
                Text(
                  product.originalPrice!.toStringAsFixed(0),
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.gray,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              const Gap(AppDimens.space8),
              Text(
                '$calculatedDiscount%',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${AppStrings.status}: ',
                style: AppTextStyles.titleMedium,
              ),
              TextSpan(
                text: AppStrings.inStock,
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildTaxText() {
    return Text(
      AppStrings.allPricesIncludeTax,
      style: AppTextStyles.bodyExtraSmall.copyWith(
        color: AppColors.gray,
      ),
    );
  }

  Widget _buildProductName() {
    return Text(
      product.name ?? AppStrings.noTitle,
      style: AppTextStyles.labelLarge.copyWith(
        color: AppColors.black,
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.description,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.black,
          ),
        ),
        const Gap(AppDimens.space8),
        Text(
          product.description ?? AppStrings.noDescription,
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildIncludes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.bouquetIncludes,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.black,
          ),
        ),
        const Gap(AppDimens.space8),
        if (product.includes != null && product.includes!.isNotEmpty) ...[
          ...product.includes!.map(
                (item) => Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimens.space4,
              ),
              child: Text(
                item.name ?? AppStrings.noTitle,
                style: AppTextStyles.bodyMedium,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
