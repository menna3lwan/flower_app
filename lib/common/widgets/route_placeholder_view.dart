import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

/// Minimal "coming soon" screen used to reserve a Commerce route before
/// its real feature UI is implemented, so `Get.toNamed(...)` never
/// crashes on an unresolved page — same reasoning as `MainView`'s own
/// doc comment. Swap the placeholder view for the real screen once the
/// feature is built; nothing about the route wiring needs to change.
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
          '$title — coming soon',
          style:
              AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
