import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/extensions/localization_extensions.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Branded launch screen, not a Figma frame — a minimal placeholder that redirects to Login on startup.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(AppDurations.splashDisplay, () {
      if (mounted) Get.offAllNamed(AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_florist_rounded, color: AppColors.white, size: AppDimens.iconSizeLarge),
            const SizedBox(height: AppDimens.space12),
            Text(
              context.l10n.appName,
              style: AppTextStyles.headlineMedium.copyWith(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
