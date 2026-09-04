import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';

/// UI-skeleton image placeholder (no CDN yet); swap for `Image.network`/`CachedNetworkImage` once real media exists.
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
      borderRadius:
          borderRadius ?? BorderRadius.circular(AppDimens.radiusMedium),
      child: Container(
        color: AppColors.primaryLight,
        alignment: Alignment.center,
        child: Icon(icon, color: AppColors.primary, size: size ?? 36),
      ),
    );
  }
}
