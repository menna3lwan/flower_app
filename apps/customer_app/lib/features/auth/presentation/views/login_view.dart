import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:common/extensions/context_extensions.dart';
import 'package:common/widgets/app_back_app_bar.dart';
import 'package:common/widgets/buttons/primary_button.dart';
import 'package:common/widgets/buttons/secondary_button.dart';
import 'package:common/widgets/inputs/app_text_field.dart';
import 'package:design_system/constants/app_dimens.dart';
import '../../../../constants/app_strings.dart';
import '../../../../routing/customer_routes.dart';
import 'package:design_system/theme/app_text_styles.dart';
import 'package:core/utils/validators.dart';
import '../cubit/login/login_cubit.dart';
import '../cubit/login/login_state.dart';

/// Login screen — matches the Figma "Login" frame: Email + Password
/// fields, "Remember me" / "Forget password?" row, primary Login button,
/// outlined "Continue as guest" button, and a "Sign up" link.
///
/// Password-visibility toggling is deliberately kept as page-local
/// `ValueNotifier` state rather than routed through [LoginCubit]: it is
/// purely cosmetic presentation state with no domain meaning, so folding
/// it into the sealed [LoginState] hierarchy would only add ceremony
/// without adding predictability.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);
  final ValueNotifier<bool> _rememberMe = ValueNotifier(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _obscurePassword.dispose();
    _rememberMe.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBackAppBar(title: AppStrings.login),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Get.offAllNamed(CustomerRoutes.main);
          } else if (state is LoginFailed) {
            context.showSnackBar(state.message);
          }
        },
        builder: (context, state) {
          final isSubmitting = state is LoginSubmitting;
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
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: AppDimens.space16),
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscurePassword,
                      builder: (context, obscure, _) {
                        return AppTextField(
                          label: AppStrings.password,
                          controller: _passwordController,
                          obscureText: obscure,
                          validator: Validators.password,
                          suffixIcon: IconButton(
                            icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => _obscurePassword.value = !obscure,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppDimens.space12),
                    Row(
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: _rememberMe,
                          builder: (context, remember, _) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: remember,
                                  onChanged: (value) => _rememberMe.value = value ?? false,
                                ),
                                Text(AppStrings.rememberMe, style: AppTextStyles.bodyMedium),
                              ],
                            );
                          },
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Get.toNamed(CustomerRoutes.forgotPassword),
                          child: const Text(AppStrings.forgetPassword),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space24),
                    PrimaryButton(
                      label: AppStrings.login,
                      isLoading: isSubmitting,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: AppDimens.space16),
                    SecondaryButton(
                      label: AppStrings.continueAsGuest,
                      onPressed: isSubmitting ? null : () => context.read<LoginCubit>().continueAsGuest(),
                    ),
                    const SizedBox(height: AppDimens.space24),
                    Center(
                      child: Wrap(
                        children: [
                          Text('${AppStrings.dontHaveAccount} ', style: AppTextStyles.bodyMedium),
                          GestureDetector(
                            onTap: () => Get.toNamed(CustomerRoutes.signUp),
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
