import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../common/extensions/context_extensions.dart';
import '../../../../common/extensions/localization_extensions.dart';
import '../../../../common/widgets/app_back_app_bar.dart';
import '../../../../common/widgets/buttons/primary_button.dart';
import '../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../common/widgets/inputs/app_text_field.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../cubit/login/login_cubit.dart';
import '../cubit/login/login_state.dart';

/// Login screen matching the Figma "Login" frame; password-visibility toggling stays page-local `ValueNotifier` state since it has no domain meaning for [LoginState].
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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBackAppBar(title: l10n.login),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Get.offAllNamed(AppRoutes.main);
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
                      label: l10n.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: AppDimens.space16),
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscurePassword,
                      builder: (context, obscure, _) {
                        return AppTextField(
                          label: l10n.password,
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
                                Text(l10n.rememberMe, style: AppTextStyles.bodyMedium),
                              ],
                            );
                          },
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                          child: Text(l10n.forgetPassword),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space24),
                    PrimaryButton(
                      label: l10n.login,
                      isLoading: isSubmitting,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: AppDimens.space16),
                    SecondaryButton(
                      label: l10n.continueAsGuest,
                      onPressed: isSubmitting ? null : () => context.read<LoginCubit>().continueAsGuest(),
                    ),
                    const SizedBox(height: AppDimens.space24),
                    Center(
                      child: Wrap(
                        children: [
                          Text('${l10n.dontHaveAccount} ', style: AppTextStyles.bodyMedium),
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.signUp),
                            child: Text(l10n.signUp, style: AppTextStyles.link),
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
