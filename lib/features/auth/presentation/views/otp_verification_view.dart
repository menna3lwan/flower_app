import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/extensions/localization_extensions.dart';
import '../../../../common/widgets/app_back_app_bar.dart';
import '../../../../common/widgets/buttons/primary_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';

/// OTP / verification-code step; kept static with no Cubit since there's no real OTP delivery to verify yet.
class OtpVerificationView extends StatelessWidget {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBackAppBar(title: l10n.passwordSectionTitle),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.verificationCodeTitle, style: AppTextStyles.headlineMedium),
              const SizedBox(height: AppDimens.space8),
              Text(l10n.verificationCodeSubtitle, style: AppTextStyles.bodyMedium),
              const SizedBox(height: AppDimens.space24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  4,
                  (index) => SizedBox(
                    width: 64,
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: AppTextStyles.titleLarge,
                      decoration: const InputDecoration(counterText: ''),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.space24),
              PrimaryButton(
                label: l10n.confirm,
                onPressed: () => Get.toNamed(AppRoutes.resetPassword),
              ),
              const SizedBox(height: AppDimens.space16),
              Center(
                child: Text(
                  l10n.resendCode,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
