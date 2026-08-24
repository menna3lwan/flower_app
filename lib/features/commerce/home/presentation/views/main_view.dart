import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

/// Placeholder for the Main shell — confirmed live that `/main` had no matching GetPage, crashing the app after a successful Login/Sign Up; this view only stops that crash.
class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_florist_rounded,
              color: AppColors.primary,
              size: 64,
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.appName,
              style: AppTextStyles.headlineMedium
                  .copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
