import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:customer_app/common/extensions/context_extensions.dart';
import 'package:customer_app/core/constants/app_assets.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

/// Figma-verified Home header: brand wordmark + a search entry point (no search API yet, so tapping surfaces "coming soon").
class HomeLogoSearchRow extends StatelessWidget {
  const HomeLogoSearchRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
      child: Row(
        children: [
          Container(
            width: AppDimens.chromeIconSize,
            height: AppDimens.chromeIconSize,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.categoryChipBackground,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              AppAssets.appIcon,
              width: AppDimens.logoLeafSize,
              height: AppDimens.logoLeafSize,
            ),
          ),
          const SizedBox(width: AppDimens.space8),
          Text(AppStrings.appName, style: AppTextStyles.logoWordmark),
          const SizedBox(width: 17),
          Expanded(child: _SearchField(onTap: () => _showComingSoon(context))),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) =>
      context.showInfoSnackBar(AppStrings.comingSoon);
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimens.searchBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.space8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.placeholderGray),
          borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              AppAssets.searchIcon,
              width: AppDimens.iconSize,
              height: AppDimens.iconSize,
            ),
            const SizedBox(width: AppDimens.space4),
            Text(
              AppStrings.search,
              style: AppTextStyles.labelMedium
                  .copyWith(color: AppColors.placeholderGray),
            ),
          ],
        ),
      ),
    );
  }
}
