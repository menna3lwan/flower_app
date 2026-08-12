import 'package:flutter/material.dart';

import 'package:design_system/constants/app_colors.dart';
import 'package:design_system/constants/app_dimens.dart';

/// Decorative placeholder used everywhere the design shows a product,
/// occasion, or avatar photo.
///
/// This is a **UI skeleton** (see project brief: no API integration at
/// this stage), so there are no real product photos or a network image
/// pipeline yet. Every "image" slot renders this instead of a broken
/// network request — once a real media/CDN integration lands, this is
/// the single widget that gets swapped for `Image.network`/
/// `CachedNetworkImage`.
class AppImagePlaceholder extends StatelessWidget {
  const AppImagePlaceholder({
    this.icon = Icons.local_florist_rounded,
    this.borderRadius,
    this.size,
    super.key,
  });

  final IconData icon;
  final BorderRadius? borderRadius;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(AppDimens.radiusMedium),
      child: Container(
        color: AppColors.primaryLight,
        alignment: Alignment.center,
        child: Icon(icon, color: AppColors.primary, size: size ?? 36),
      ),
    );
  }
}
