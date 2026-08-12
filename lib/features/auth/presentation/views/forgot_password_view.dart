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
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../cubit/forgot_password/forgot_password_cubit.dart';
import '../cubit/forgot_password/forgot_password_state.dart';

/// "Forget password" screen — email entry step of the password recovery flow.
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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBackAppBar(title: l10n.passwordSectionTitle),
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordEmailSent) {
            Get.toNamed(AppRoutes.otpVerification);
          } else if (state is ForgotPasswordFailed) {
            context.showSnackBar(state.message);
          }
        },
        builder: (context, state) {
          final isSubmitting = state is ForgotPasswordSubmitting;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.space16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.forgotPasswordTitle, style: AppTextStyles.headlineMedium, textAlign: TextAlign.center),
                    const SizedBox(height: AppDimens.space8),
                    Text(
                      l10n.forgotPasswordSubtitle,
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimens.space24),
                    AppTextField(
                      label: l10n.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: AppDimens.space24),
                    PrimaryButton(
                      label: l10n.confirm,
                      isLoading: isSubmitting,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<ForgotPasswordCubit>().sendResetEmail(_emailController.text.trim());
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
