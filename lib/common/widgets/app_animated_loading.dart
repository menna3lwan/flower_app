import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_animations.dart';
import '../../core/constants/app_dimens.dart';
import '../extensions/context_extensions.dart';

class AppAnimatedLoading extends StatelessWidget {
  const AppAnimatedLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.35,
      child: Center(
        child: Lottie.asset(
          AppAnimations.loading,
          width: AppDimens.space120,
          height: AppDimens.space120,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
