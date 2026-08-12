import 'package:flutter/material.dart';

import 'package:design_system/constants/app_colors.dart';
import 'package:design_system/theme/app_text_styles.dart';

/// Temporary landing screen for the Rider app scaffold.
///
/// **This is scaffolding, not a feature.** Mirrors `customer_app`'s
/// `FoundationPreviewScreen` role: it exists only to give
/// [RiderApp.home] something to render before the first real Rider
/// screen (Onboarding) is implemented, at which point this should be
/// deleted and `RiderApp` switched to `initialRoute: RiderRoutes.onboarding`.
class RiderFoundationPreviewScreen extends StatelessWidget {
  const RiderFoundationPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Text(
          'Flowery Rider\narchitecture scaffold — no screens implemented yet',
          textAlign: TextAlign.center,
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
