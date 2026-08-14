import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:customer_app/common/extensions/context_extensions.dart';
import 'package:customer_app/common/formatters/capitalize_first_letter_formatter.dart';
import 'package:customer_app/common/widgets/app_back_app_bar.dart';
import 'package:customer_app/common/widgets/buttons/primary_button.dart';
import 'package:customer_app/common/widgets/inputs/app_outlined_text_field.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/routing/customer_routes.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';
import 'package:customer_app/core/utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../intent/auth_intent.dart';
import '../state/auth_state.dart';

/// Sign up screen — matches the Figma "Sign up" frame.
class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final ValueNotifier<Gender> _gender = ValueNotifier(Gender.female);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _gender.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().onIntent(
            SignUpRequested(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              phoneNumber: _phoneController.text.trim(),
              gender: _gender.value,
            ),
          );
    }
  }

  String? _validateRequired(String? value) {
    return Validators.required(value) == null ? null : AppStrings.fieldRequired;
  }

  String? _validateEmail(String? value) {
    return Validators.email(value) == null ? null : AppStrings.invalidEmail;
  }

  String? _validatePassword(String? value) {
    return Validators.password(value) == null ? null : AppStrings.invalidPassword;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.confirmPasswordRequired;
    return value == _passwordController.text ? null : AppStrings.passwordsDoNotMatch;
  }

  String? _validatePhone(String? value) {
    return Validators.phone(value) == null ? null : AppStrings.invalidPhoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBackAppBar(title: AppStrings.signUp),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignUpSuccess) {
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
                    Row(
                      children: [
                        Expanded(
                          child: AppOutlinedTextField(
                            label: AppStrings.firstName,
                            hint: AppStrings.signUpFirstNameHint,
                            controller: _firstNameController,
                            validator: _validateRequired,
                            textCapitalization: TextCapitalization.sentences,
                            inputFormatters: const [CapitalizeFirstLetterFormatter()],
                          ),
                        ),
                        const SizedBox(width: AppDimens.space16),
                        Expanded(
                          child: AppOutlinedTextField(
                            label: AppStrings.lastName,
                            hint: AppStrings.signUpLastNameHint,
                            controller: _lastNameController,
                            validator: _validateRequired,
                            textCapitalization: TextCapitalization.sentences,
                            inputFormatters: const [CapitalizeFirstLetterFormatter()],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space24),
                    AppOutlinedTextField(
                      label: AppStrings.email,
                      hint: AppStrings.signUpEmailHint,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: AppDimens.space24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppOutlinedTextField(
                            label: AppStrings.password,
                            hint: AppStrings.signUpPasswordHint,
                            controller: _passwordController,
                            obscureText: true,
                            validator: _validatePassword,
                          ),
                        ),
                        const SizedBox(width: AppDimens.space16),
                        Expanded(
                          child: AppOutlinedTextField(
                            label: AppStrings.confirmPassword,
                            hint: AppStrings.signUpConfirmPasswordHint,
                            controller: _confirmPasswordController,
                            obscureText: true,
                            validator: _validateConfirmPassword,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space24),
                    AppOutlinedTextField(
                      label: AppStrings.phoneNumber,
                      hint: AppStrings.signUpPhoneNumberHint,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: _validatePhone,
                    ),
                    const SizedBox(height: AppDimens.space20),
                    Text(AppStrings.gender, style: AppTextStyles.titleMedium),
                    ValueListenableBuilder<Gender>(
                      valueListenable: _gender,
                      builder: (context, gender, _) {
                        return Row(
                          children: [
                            Radio<Gender>(
                              value: Gender.female,
                              groupValue: gender,
                              onChanged: (value) => _gender.value = value!,
                            ),
                            Text(AppStrings.female),
                            const SizedBox(width: AppDimens.space16),
                            Radio<Gender>(
                              value: Gender.male,
                              groupValue: gender,
                              onChanged: (value) => _gender.value = value!,
                            ),
                            Text(AppStrings.male),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppDimens.space16),
                    Wrap(
                      children: [
                        Text('${AppStrings.termsAgreement} ', style: AppTextStyles.bodySmall),
                        Text(AppStrings.termsAndConditions, style: AppTextStyles.link),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space24),
                    PrimaryButton(
                      label: AppStrings.signUp,
                      isLoading: isSubmitting,
                      onPressed: _submit,
                    ),
                    // Figma Dev Mode ("Sign up" button group): 16px gap to
                    // the "Already have an account?" line, not 24px.
                    const SizedBox(height: AppDimens.space16),
                    Center(
                      child: Wrap(
                        children: [
                          Text('${AppStrings.alreadyHaveAccount} ', style: AppTextStyles.bodyMedium),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Text(AppStrings.login, style: AppTextStyles.link),
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
