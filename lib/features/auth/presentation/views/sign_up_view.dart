import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../common/extensions/context_extensions.dart';
import '../../../../common/extensions/localization_extensions.dart';
import '../../../../common/widgets/app_back_app_bar.dart';
import '../../../../common/widgets/buttons/primary_button.dart';
import '../../../../common/widgets/inputs/app_text_field.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../cubit/sign_up/sign_up_cubit.dart';

/// Sign up screen matching the Figma "Sign up" frame.
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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBackAppBar(title: l10n.signUp),
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            Get.offAllNamed(AppRoutes.main);
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
                            label: l10n.firstName,
                            controller: _firstNameController,
                            validator: Validators.required,
                          ),
                        ),
                        const SizedBox(width: AppDimens.space12),
                        Expanded(
                          child: AppTextField(
                            label: l10n.lastName,
                            controller: _lastNameController,
                            validator: Validators.required,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space16),
                    AppTextField(
                      label: l10n.email,
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
                            label: l10n.password,
                            controller: _passwordController,
                            obscureText: true,
                            validator: Validators.password,
                          ),
                        ),
                        const SizedBox(width: AppDimens.space12),
                        Expanded(
                          child: AppTextField(
                            label: l10n.confirmPassword,
                            controller: _confirmPasswordController,
                            obscureText: true,
                            validator: (value) => Validators.confirmPassword(value, _passwordController.text),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space16),
                    AppTextField(
                      label: l10n.phoneNumber,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: Validators.phone,
                    ),
                    const SizedBox(height: AppDimens.space20),
                    Text(l10n.gender, style: AppTextStyles.titleMedium),
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
                            Text(l10n.female),
                            const SizedBox(width: AppDimens.space16),
                            Radio<Gender>(
                              value: Gender.male,
                              groupValue: gender,
                              onChanged: (value) => _gender.value = value!,
                            ),
                            Text(l10n.male),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppDimens.space16),
                    Wrap(
                      children: [
                        Text('${l10n.termsAgreement} ', style: AppTextStyles.bodySmall),
                        Text(l10n.termsAndConditions, style: AppTextStyles.link),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space24),
                    PrimaryButton(
                      label: l10n.signUp,
                      isLoading: isSubmitting,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: AppDimens.space24),
                    Center(
                      child: Wrap(
                        children: [
                          Text('${l10n.alreadyHaveAccount} ', style: AppTextStyles.bodyMedium),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Text(l10n.login, style: AppTextStyles.link),
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
