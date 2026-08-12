import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:common/extensions/context_extensions.dart';
import 'package:common/widgets/app_back_app_bar.dart';
import 'package:common/widgets/buttons/primary_button.dart';
import 'package:common/widgets/inputs/app_text_field.dart';
import 'package:design_system/constants/app_dimens.dart';
import '../../../../constants/app_strings.dart';
import 'package:shared/domain/entities/user_entity.dart';
import '../../../../routing/customer_routes.dart';
import 'package:design_system/theme/app_text_styles.dart';
import 'package:core/utils/validators.dart';
import '../cubit/sign_up/sign_up_cubit.dart';
import '../cubit/sign_up/sign_up_state.dart';

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
      context.read<SignUpCubit>().signUp(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            phoneNumber: _phoneController.text.trim(),
            gender: _gender.value,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBackAppBar(title: AppStrings.signUp),
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            Get.offAllNamed(CustomerRoutes.main);
          } else if (state is SignUpFailed) {
            context.showSnackBar(state.message);
          }
        },
        builder: (context, state) {
          final isSubmitting = state is SignUpSubmitting;
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
                          child: AppTextField(
                            label: AppStrings.firstName,
                            controller: _firstNameController,
                            validator: Validators.required,
                          ),
                        ),
                        const SizedBox(width: AppDimens.space12),
                        Expanded(
                          child: AppTextField(
                            label: AppStrings.lastName,
                            controller: _lastNameController,
                            validator: Validators.required,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space16),
                    AppTextField(
                      label: AppStrings.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: AppDimens.space16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: AppStrings.password,
                            controller: _passwordController,
                            obscureText: true,
                            validator: Validators.password,
                          ),
                        ),
                        const SizedBox(width: AppDimens.space12),
                        Expanded(
                          child: AppTextField(
                            label: AppStrings.confirmPassword,
                            controller: _confirmPasswordController,
                            obscureText: true,
                            validator: (value) => Validators.confirmPassword(value, _passwordController.text),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space16),
                    AppTextField(
                      label: AppStrings.phoneNumber,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: Validators.phone,
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
                            const Text(AppStrings.female),
                            const SizedBox(width: AppDimens.space16),
                            Radio<Gender>(
                              value: Gender.male,
                              groupValue: gender,
                              onChanged: (value) => _gender.value = value!,
                            ),
                            const Text(AppStrings.male),
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
                    const SizedBox(height: AppDimens.space24),
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
