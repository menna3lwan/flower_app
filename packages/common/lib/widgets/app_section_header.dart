import 'package:flutter/material.dart';

import 'package:design_system/constants/app_dimens.dart';
import 'package:design_system/theme/app_text_styles.dart';

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    this.subtitle,
    this.onViewAllTap,
    this.viewAllLabel,
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onViewAllTap;

  final String? viewAllLabel;

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
          if (onViewAllTap != null && viewAllLabel != null)
            GestureDetector(
              onTap: onViewAllTap,
              child: Text(viewAllLabel!, style: AppTextStyles.link),
            ),
        ],
      ),
    );
  }
}
