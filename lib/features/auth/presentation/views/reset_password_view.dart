import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../common/extensions/context_extensions.dart';
import '../../../../common/extensions/localization_extensions.dart';
import '../../../../common/widgets/app_back_app_bar.dart';
import '../../../../common/widgets/buttons/primary_button.dart';
import '../../../../common/widgets/inputs/app_text_field.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../cubit/reset_password/reset_password_cubit.dart';
import '../cubit/reset_password/reset_password_state.dart';

/// "Reset password" screen — Current/New/Confirm password fields.
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBackAppBar(title: l10n.resetPasswordTitle),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            Get.offAllNamed(AppRoutes.login);
          } else if (state is ResetPasswordFailed) {
            context.showSnackBar(state.message);
          }
        },
        builder: (context, state) {
          final isSubmitting = state is ResetPasswordSubmitting;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.space16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: l10n.currentPassword,
                      controller: _currentPasswordController,
                      obscureText: true,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: AppDimens.space16),
                    AppTextField(
                      label: l10n.newPassword,
                      controller: _newPasswordController,
                      obscureText: true,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: AppDimens.space16),
                    AppTextField(
                      label: l10n.confirmPassword,
                      controller: _confirmPasswordController,
                      obscureText: true,
                      validator: (value) => Validators.confirmPassword(value, _newPasswordController.text),
                    ),
                    const SizedBox(height: AppDimens.space24),
                    PrimaryButton(
                      label: l10n.update,
                      isLoading: isSubmitting,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<ResetPasswordCubit>().resetPassword(
                                currentPassword: _currentPasswordController.text,
                                newPassword: _newPasswordController.text,
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
