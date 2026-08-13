import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:customer_app/common/extensions/context_extensions.dart';
import 'package:customer_app/common/widgets/app_back_app_bar.dart';
import 'package:customer_app/common/widgets/buttons/primary_button.dart';
import 'package:customer_app/common/widgets/buttons/secondary_button.dart';
import 'package:customer_app/common/widgets/inputs/app_text_field.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import '../../../../core/routing/customer_routes.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';
import 'package:customer_app/core/utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../intent/auth_intent.dart';
import '../state/auth_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _rememberMe = ValueNotifier(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rememberMe.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().onIntent(
            LoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  String? _validateEmail(String? value) {
    return Validators.email(value) == null ? null : AppStrings.invalidEmail;
  }

  String? _validatePassword(String? value) {
    return Validators.password(value) == null ? null : AppStrings.invalidPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBackAppBar(
        title: AppStrings.login,
        titleStyle: AppTextStyles.appBarTitleEmphasis,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
            Get.offAllNamed(CustomerRoutes.main);
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
                      label: AppStrings.email,
                      hint: AppStrings.enterYourEmail,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isSubmitting,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: AppDimens.space24),
                    AppTextField(
                      label: AppStrings.password,
                      hint: AppStrings.enterYourPassword,
                      controller: _passwordController,
                      obscureText: true,
                      enabled: !isSubmitting,
                      validator: _validatePassword,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: _rememberMe,
                          builder: (context, remember, _) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: Checkbox(
                                    value: remember,
                                    onChanged:
                                        isSubmitting ? null : (value) => _rememberMe.value = value ?? false,
                                  ),
                                ),
                                Text(AppStrings.rememberMe, style: AppTextStyles.bodyExtraSmall),
                              ],
                            );
                          },
                        ),
                        GestureDetector(
                          onTap: isSubmitting ? null : () => Get.toNamed(CustomerRoutes.forgotPassword),
                          child: Text(
                            AppStrings.forgetPassword,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space48),
                    PrimaryButton(
                      label: AppStrings.login,
                      isLoading: isSubmitting,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: AppDimens.space16),
                    SecondaryButton(
                      label: AppStrings.continueAsGuest,
                      onPressed:
                          isSubmitting ? null : () => context.read<AuthCubit>().onIntent(const GuestLoginRequested()),
                    ),
                    const SizedBox(height: AppDimens.space16),
                    Center(
                      child: Wrap(
                        children: [
                          Text('${AppStrings.dontHaveAccount} ', style: AppTextStyles.bodyMedium),
                          GestureDetector(
                            onTap: isSubmitting ? null : () => Get.toNamed(CustomerRoutes.signUp),
                            child: Text(AppStrings.signUp, style: AppTextStyles.link),
                          ),
                        ],
                      ),
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
