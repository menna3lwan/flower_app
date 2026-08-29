import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_animations.dart';
import '../../core/constants/app_dimens.dart';

class AppAnimatedLoading extends StatelessWidget {
  const AppAnimatedLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 140,
        maxHeight: 200,
      ),

      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: Lottie.asset(
            AppAnimations.loading,
            width: AppDimens.space120,
            height: AppDimens.space120,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
