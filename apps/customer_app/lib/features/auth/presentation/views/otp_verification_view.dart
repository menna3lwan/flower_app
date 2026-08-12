import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:common/widgets/app_back_app_bar.dart';
import 'package:common/widgets/buttons/primary_button.dart';
import 'package:design_system/constants/app_colors.dart';
import 'package:design_system/constants/app_dimens.dart';
import '../../../../constants/app_strings.dart';
import '../../../../routing/customer_routes.dart';
import 'package:design_system/theme/app_text_styles.dart';

class OtpVerificationView extends StatelessWidget {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBackAppBar(title: AppStrings.passwordSectionTitle),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.verificationCodeTitle, style: AppTextStyles.headlineMedium),
              const SizedBox(height: AppDimens.space8),
              Text(AppStrings.verificationCodeSubtitle, style: AppTextStyles.bodyMedium),
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
                label: AppStrings.confirm,
                onPressed: () => Get.toNamed(CustomerRoutes.resetPassword),
              ),
              const SizedBox(height: AppDimens.space16),
              Center(
                child: Text(
                  AppStrings.resendCode,
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
