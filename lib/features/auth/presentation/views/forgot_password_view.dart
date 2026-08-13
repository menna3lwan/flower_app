import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:customer_app/common/extensions/context_extensions.dart';
import 'package:customer_app/common/widgets/app_back_app_bar.dart';
import 'package:customer_app/common/widgets/buttons/primary_button.dart';
import 'package:customer_app/common/widgets/inputs/app_text_field.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import '../../../../core/routing/customer_routes.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';
import 'package:customer_app/core/utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../intent/auth_intent.dart';
import '../state/auth_state.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBackAppBar(title: AppStrings.passwordSectionTitle),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordResetEmailSent) {
            Get.toNamed(CustomerRoutes.otpVerification);
          } else if (state is AuthFailed) {
            context.showSnackBar(state.message);
          }
        },
        builder: (context, state) {
          final isSubmitting = state is AuthLoading;
          return SafeArea(
            // Matches Login/Sign Up/Reset Password: scrollable instead of
            // a plain Padding, so the form doesn't overflow when the
            // keyboard opens on shorter screens.
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.space16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Figma Dev Mode (Forget password frame, node 74:6982):
                    // title+subtitle form one centered block. `textAlign:
                    // center` alone doesn't center them here — the outer
                    // Column is left-aligned (`CrossAxisAlignment.start`),
                    // so a single-line Text like the title only gets a box
                    // as wide as its own text and stays pinned to the left
                    // edge. Wrapping both in a full-width, center-aligned
                    // Column fixes that regardless of line count.
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Title is the "Title Large" token (18px/w600),
                          // not headlineMedium (22px/w700) — headlineMedium
                          // was too heavy/large for this screen's title.
                          Text(AppStrings.forgotPasswordTitle, style: AppTextStyles.titleLarge, textAlign: TextAlign.center),
                          // Figma measures 16px between the title and subtitle.
                          const SizedBox(height: AppDimens.space16),
                          Text(
                            AppStrings.forgotPasswordSubtitle,
                            style: AppTextStyles.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    // Figma measures ~32px between the subtitle and the
                    // Email field.
                    const SizedBox(height: AppDimens.space32),
                    AppTextField(
                      label: AppStrings.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    // Figma measures ~48px between the field and the
                    // primary button (same pre-button gap as Login/Reset
                    // Password — a consistent app-wide pattern).
                    const SizedBox(height: AppDimens.space48),
                    PrimaryButton(
                      label: AppStrings.confirm,
                      isLoading: isSubmitting,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context
                              .read<AuthCubit>()
                              .onIntent(ForgotPasswordRequested(_emailController.text.trim()));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
