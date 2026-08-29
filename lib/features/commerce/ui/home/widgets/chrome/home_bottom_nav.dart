import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:customer_app/common/extensions/context_extensions.dart';
import 'package:customer_app/core/constants/app_assets.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/routing/customer_routes.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

/// Figma-verified bottom navigation bar. Home is the only tab with a real destination today;
/// Categories routes to the existing catalog screen, Cart/Profile surface "coming soon" until
/// those features exist — never a crash from navigating to an unregistered route.
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.bottomNavHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.dividerLight)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(
            icon: AppAssets.navHomeIcon,
            label: AppStrings.homeNavLabel,
            isActive: true,
            onTap: () {},
          ),
          _NavItem(
            icon: AppAssets.navCategoriesIcon,
            label: AppStrings.categories,
            isActive: false,
            onTap: () => Get.toNamed(CustomerRoutes.categories),
          ),
          _NavItem(
            icon: AppAssets.navCartIcon,
            label: AppStrings.cart,
            isActive: false,
            onTap: () => context.showInfoSnackBar(AppStrings.comingSoon),
          ),
          _NavItem(
            icon: AppAssets.navProfileIcon,
            label: AppStrings.profile,
            isActive: false,
            onTap: () => context.showInfoSnackBar(AppStrings.comingSoon),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.navInactive;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: AppDimens.iconSize,
            height: AppDimens.iconSize,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(height: AppDimens.space4),
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: color)),
        ],
      ),
    );
  }
}
