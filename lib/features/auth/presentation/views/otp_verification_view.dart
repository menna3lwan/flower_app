import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:customer_app/common/extensions/context_extensions.dart';
import 'package:customer_app/common/widgets/app_back_app_bar.dart';
import 'package:customer_app/common/widgets/buttons/primary_button.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import '../../../../core/routing/customer_routes.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';
import '../cubit/auth_cubit.dart';
import '../intent/auth_intent.dart';
import '../state/auth_state.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  static const double _codeBoxWidth = 74;
  static const double _codeBoxHeight = 68;
  static const int _codeLength = 4;

  late final String _email;
  final _controllers =
      List.generate(_codeLength, (_) => TextEditingController());
  final _focusNodes = List.generate(_codeLength, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    _email = arguments is String ? arguments : '';
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _submit(BuildContext context) {
    if (_code.length < _codeLength) {
      context.showSnackBar(AppStrings.verificationCodeIncomplete);
      return;
    }
    context
        .read<AuthCubit>()
        .onIntent(VerifyCodeRequested(email: _email, code: _code));
  }

  void _resend(BuildContext context) {
    context.read<AuthCubit>().onIntent(ForgotPasswordRequested(_email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBackAppBar(title: AppStrings.passwordSectionTitle),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthCodeVerified) {
            Get.offAllNamed(CustomerRoutes.login);
          } else if (state is AuthPasswordResetEmailSent) {
            // Reached only via `_resend` above (the initial email send
            // already happened on Forgot Password, before this screen
            // existed) — surface it as a resend confirmation, not a
            // navigation trigger.
            context.showSnackBar(AppStrings.verificationCodeResent);
          } else if (state is AuthFailed) {
            context.showSnackBar(state.message);
          }
        },
        builder: (context, state) {
          final isSubmitting = state is AuthLoading;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.verificationCodeTitle,
                          style: AppTextStyles.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimens.space16),
                        Text(
                          AppStrings.verificationCodeSubtitle,
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimens.space32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var index = 0; index < _codeLength; index++) ...[
                        if (index > 0) const SizedBox(width: AppDimens.space16),
                        SizedBox(
                          width: _codeBoxWidth,
                          height: _codeBoxHeight,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            enabled: !isSubmitting,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: AppTextStyles.titleLarge,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(counterText: ''),
                            onChanged: (value) => _onDigitChanged(index, value),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppDimens.space24),
                  PrimaryButton(
                    label: AppStrings.confirm,
                    isLoading: isSubmitting,
                    onPressed: () => _submit(context),
                  ),
                  const SizedBox(height: AppDimens.space16),
                  Center(
                    child: GestureDetector(
                      onTap: isSubmitting ? null : () => _resend(context),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: '${AppStrings.resendCodePrefix} ',
                                style: AppTextStyles.bodyMedium),
                            TextSpan(
                                text: AppStrings.resendCodeAction,
                                style: AppTextStyles.link),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
