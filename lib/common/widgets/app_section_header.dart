import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    this.subtitle,
    this.onViewAllTap,
    this.viewAllLabel,
    this.titleStyle,
    this.viewAllStyle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onViewAllTap;

  final String? viewAllLabel;

  /// Null falls back to [AppTextStyles.titleLarge]/[AppTextStyles.link].
  final TextStyle? titleStyle;
  final TextStyle? viewAllStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: titleStyle ?? AppTextStyles.titleLarge),
                if (subtitle != null) ...[
                  const SizedBox(height: AppDimens.space4),
                  Text(subtitle!, style: AppTextStyles.bodySmall),
                ],
              ],
            ),
          ),
          if (onViewAllTap != null && viewAllLabel != null)
            GestureDetector(
              onTap: onViewAllTap,
              child: Text(
                viewAllLabel!,
                style: viewAllStyle ?? AppTextStyles.link,
              ),
            ),
        ],
      ),
    );
  }
}
