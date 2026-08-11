import 'package:flutter/material.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';

/// "{Title}" + "View All" row used above every horizontal product/category
/// list on Home, and as the page header on full listing screens.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    this.subtitle,
    this.onViewAllTap,
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onViewAllTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleLarge),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: AppTextStyles.bodySmall),
                ],
              ],
            ),
          ),
          if (onViewAllTap != null)
            GestureDetector(
              onTap: onViewAllTap,
              child: Text('View All', style: AppTextStyles.link),
            ),
        ],
      ),
    );
  }
}
