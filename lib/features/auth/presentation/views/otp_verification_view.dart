import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:customer_app/common/widgets/app_back_app_bar.dart';
import 'package:customer_app/common/widgets/buttons/primary_button.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import '../../../../core/routing/customer_routes.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

class OtpVerificationView extends StatelessWidget {
  const OtpVerificationView({super.key});

  // Figma Dev Mode (Verification code frame, node 74:7065): each code box
  // is 74×68 — distinctly bigger than a standard AppTextField and unique
  // to this one screen, so it's kept as an explicit, Figma-cited literal
  // rather than force-fit into an unrelated AppDimens token.
  static const double _codeBoxWidth = 74;
  static const double _codeBoxHeight = 68;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBackAppBar(title: AppStrings.passwordSectionTitle),
      body: SafeArea(
        // Matches Login/Sign Up/Reset Password: scrollable instead of a
        // plain Padding, so this doesn't overflow once the number
        // keyboard is open on shorter screens.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Same centered title+subtitle block pattern as Forgot
              // Password — see that screen's comment for why a plain
              // `textAlign: center` isn't enough on its own here.
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.verificationCodeTitle,
                      style: AppTextStyles.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimens.space16),
                    Text(
                      AppStrings.verificationCodeSubtitle,
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Figma measures ~32px between the subtitle and the code boxes.
              const SizedBox(height: AppDimens.space32),
              // Figma lays the 4 boxes out as a fixed-16px-gap group,
              // centered as a block — not spread edge-to-edge with
              // `spaceBetween` (which stretches the gaps to fill the row
              // instead of keeping them at a fixed 16px).
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var index = 0; index < 4; index++) ...[
                    if (index > 0) const SizedBox(width: AppDimens.space16),
                    SizedBox(
                      width: _codeBoxWidth,
                      height: _codeBoxHeight,
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: AppTextStyles.titleLarge,
                        decoration: const InputDecoration(counterText: ''),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppDimens.space24),
              // Figma's Verification code frame has no button on it (entry
              // of the 4th digit is the only progression shown) — kept
              // here anyway: there's no auto-advance logic wired to this
              // static screen (no Cubit), so removing it would strand the
              // user with no way to reach Reset Password. Flagged in the
              // review report rather than silently dropped or built out.
              PrimaryButton(
                label: AppStrings.confirm,
                onPressed: () => Get.toNamed(CustomerRoutes.resetPassword),
              ),
              const SizedBox(height: AppDimens.space16),
              // Figma: only the "Resend" word is pink/underlined, the
              // leading "Didn't receive the code?" stays default-colored
              // — matches the two-tone rich-text pattern already used for
              // Sign Up's "Terms & Conditions" line.
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${AppStrings.resendCodePrefix} ', style: AppTextStyles.bodyMedium),
                      TextSpan(text: AppStrings.resendCodeAction, style: AppTextStyles.link),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
