import 'package:flutter/material.dart';

import 'package:design_system/constants/app_colors.dart';

/// Shared full-screen/section loading indicator so every `Loading` state
/// variant renders identically across features.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}
