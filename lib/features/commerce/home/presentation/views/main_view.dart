import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

/// Placeholder for the Main shell (bottom nav: Home / Categories / Cart /
/// Profile) — confirmed missing live: `CustomerRoutes.main` had no
/// matching `GetPage`, so a real successful Login/Sign Up crashed the
/// whole app (`Null check operator used on a null value` inside GetX's
/// `PageRedirect.page`, since it could never resolve `/main` to a page).
///
/// The Home/Catalog/Cart/Profile feature itself (see `HomeCubit`,
/// `CatalogRepository`) is out of scope here — this view only exists so
/// a successful authentication has *somewhere real* to land instead of
/// crashing, mirroring `SplashView`'s own "minimal, on-brand placeholder"
/// pattern until the actual Main shell is built.
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
