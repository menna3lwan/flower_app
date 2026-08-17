import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:customer_app/common/extensions/context_extensions.dart';
import 'package:customer_app/common/widgets/app_back_app_bar.dart';
import 'package:customer_app/common/widgets/buttons/primary_button.dart';
import 'package:customer_app/common/widgets/inputs/app_text_field.dart';
import 'package:customer_app/common/widgets/inputs/password_rules_checklist.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import '../../../../core/routing/customer_routes.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';
import 'package:customer_app/core/utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../intent/auth_intent.dart';
import '../mappers/auth_failure_message.dart';
import '../state/auth_state.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final String _email;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    _email = arguments is String ? arguments : '';
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().onIntent(
            ResetPasswordRequested(
              email: _email,
              newPassword: _newPasswordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Figma: the Reset Password screen's AppBar reads "Password", the
      // same generic label used across the whole password-recovery flow
      // (Forgot Password, OTP) — not the "Reset password" body heading.
      appBar: AppBackAppBar(title: AppStrings.passwordSectionTitle),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordResetSuccess) {
            // Clear the whole reset chain (Forgot Password → OTP → here)
            // off the stack so Back cannot walk into a spent OTP screen.
            Get.offAllNamed(CustomerRoutes.login);
            context.showSuccessSnackBar(AppStrings.passwordResetSuccess);
          } else if (state is AuthFailed) {
            context.showErrorSnackBar(state.failure.localizedMessage);
          }
        },
        builder: (context, state) {
          final isSubmitting = state is AuthLoading;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.space16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        AppStrings.resetPasswordSubtitle,
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppDimens.space32),
                    AppTextField(
                      label: AppStrings.newPassword,
                      controller: _newPasswordController,
                      obscureText: true,
                      enabled: !isSubmitting,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: AppDimens.space8),
                    Text(
                      AppStrings.passwordRequirementsTitle,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppDimens.space4),
                    PasswordRulesChecklist(
                      controller: _newPasswordController,
                    ),
                    const SizedBox(height: AppDimens.space24),
                    AppTextField(
                      label: AppStrings.confirmPassword,
                      controller: _confirmPasswordController,
                      obscureText: true,
                      enabled: !isSubmitting,
                      validator: (value) => Validators.confirmPassword(
                        value,
                        _newPasswordController.text,
                      ),
                    ),
                    const SizedBox(height: AppDimens.space48),
                    PrimaryButton(
                      label: AppStrings.update,
                      isLoading: isSubmitting,
                      onPressed: _submit,
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
