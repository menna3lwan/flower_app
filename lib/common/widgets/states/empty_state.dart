import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

/// Centered icon + message used for empty search results, empty cart,
/// empty order lists, etc. — one widget instead of ad-hoc `Center(Column(...))`
/// blocks duplicated per screen.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.message,
    this.icon = Icons.search_rounded,
    super.key,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.primary),
            const SizedBox(height: AppDimens.space16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
