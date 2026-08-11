import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/app_back_app_bar.dart';
import '../../../../common/widgets/buttons/primary_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';

/// OTP / verification-code step of the password recovery flow.
///
/// Kept as a static, self-contained layout (no dedicated Cubit) since at
/// this skeleton stage there is no real OTP delivery to verify against —
/// it exists to complete the Figma flow (Forget password > Verification
/// code > Reset password) and is wired for a Cubit the moment that
/// backend exists.
class OtpVerificationView extends StatelessWidget {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBackAppBar(title: 'Password'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Verification code', style: AppTextStyles.headlineMedium),
              const SizedBox(height: AppDimens.space8),
              Text('Enter the 4-digit code sent to your email', style: AppTextStyles.bodyMedium),
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
                label: 'Confirm',
                onPressed: () => Get.toNamed(AppRoutes.resetPassword),
              ),
              const SizedBox(height: AppDimens.space16),
              Center(
                child: Text(
                  "Didn't receive the code? Resend",
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
