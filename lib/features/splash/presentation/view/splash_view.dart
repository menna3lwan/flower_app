import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../common/extensions/localization_extensions.dart';
import '../../../../common/widgets/states/error_view.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/splash_destination.dart';
import '../cubit/splash_cubit.dart';
import '../intent/splash_intent.dart';
import '../state/splash_state.dart';

/// Branded launch screen, not a Figma frame — renders [SplashState] and dispatches [SplashIntent]s only.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().handleIntent(const SplashStarted());
  }

  void _navigate(SplashDestination destination) {
    final route = switch (destination) {
      SplashDestination.login => AppRoutes.login,
    };
    Get.offAllNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashReady) {
            _navigate(state.destination);
          }
        },
        builder: (context, state) {
          if (state is SplashFailed) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<SplashCubit>().handleIntent(const SplashRetried()),
            );
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppAssets.appLogo, width: AppDimens.splashLogoWidth),
                const SizedBox(height: AppDimens.space12),
                Text(
                  context.l10n.appName,
                  style: AppTextStyles.headlineMedium.copyWith(color: AppColors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
