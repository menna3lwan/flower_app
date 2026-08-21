import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import '../../../../core/routing/customer_routes.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

/// Branded launch screen. Not present as a distinct frame in the Figma
/// file (the design starts at Login), but every shipped app needs a
/// splash — this is a minimal, on-brand placeholder that redirects to
/// Login once the (currently instant) startup work would complete.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) Get.offAllNamed(CustomerRoutes.login);
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
            const Icon(Icons.local_florist_rounded,
                color: AppColors.white, size: 72),
            const SizedBox(height: 12),
            Text(
              AppStrings.appName,
              style:
                  AppTextStyles.headlineMedium.copyWith(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
