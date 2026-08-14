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
import 'package:customer_app/core/utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../intent/auth_intent.dart';
import '../state/auth_state.dart';

/// "Reset password" screen — Current/New/Confirm password fields.
///
/// Reached from Profile (change password while signed in), not from the
/// Forgot Password/Verification chain — see [OtpVerificationView]'s doc
/// comment for why: this screen asks for the user's *current* password,
/// which a forgot-password user wouldn't have.
class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    return Validators.password(value) == null ? null : AppStrings.invalidPassword;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.confirmPasswordRequired;
    return value == _newPasswordController.text ? null : AppStrings.passwordsDoNotMatch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBackAppBar(title: AppStrings.resetPasswordTitle),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordResetSuccess) {
            Get.offAllNamed(CustomerRoutes.login);
          } else if (state is AuthFailed) {
            context.showSnackBar(state.message);
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
                    AppTextField(
                      label: AppStrings.currentPassword,
                      controller: _currentPasswordController,
                      obscureText: true,
                      validator: _validatePassword,
                    ),
                    // Figma Dev Mode (Reset password frame, node 76:7947):
                    // 24px between stacked fields, not 16px.
                    const SizedBox(height: AppDimens.space24),
                    AppTextField(
                      label: AppStrings.newPassword,
                      controller: _newPasswordController,
                      obscureText: true,
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: AppDimens.space24),
                    AppTextField(
                      label: AppStrings.confirmPassword,
                      controller: _confirmPasswordController,
                      obscureText: true,
                      validator: _validateConfirmPassword,
                    ),
                    // Figma measures ~48px before the primary button here
                    // too — same pre-button gap as Login/Forgot Password.
                    const SizedBox(height: AppDimens.space48),
                    PrimaryButton(
                      label: AppStrings.update,
                      isLoading: isSubmitting,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<AuthCubit>().onIntent(
                                ResetPasswordRequested(
                                  currentPassword: _currentPasswordController.text,
                                  newPassword: _newPasswordController.text,
                                ),
                              );
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
