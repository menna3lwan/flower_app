import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

/// Minimal "coming soon" screen reserving a Commerce route before its real UI exists.
class RoutePlaceholderView extends StatelessWidget {
  const RoutePlaceholderView({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title — ${AppStrings.comingSoon}',
          style:
              AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
