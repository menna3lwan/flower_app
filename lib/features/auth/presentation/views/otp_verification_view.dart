import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:customer_app/common/extensions/context_extensions.dart';
import 'package:customer_app/common/widgets/app_back_app_bar.dart';
import 'package:customer_app/common/widgets/buttons/primary_button.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import '../../../../core/routing/customer_routes.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';
import 'package:customer_app/core/utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../intent/auth_intent.dart';
import '../mappers/auth_failure_message.dart';
import '../state/auth_state.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  static const int _codeLength = 4;

  late final String _email;
  final _controllers =
      List.generate(_codeLength, (_) => TextEditingController());
  final _focusNodes = List.generate(_codeLength, (_) => FocusNode());

  final ValueNotifier<String?> _codeError = ValueNotifier(null);

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
    _codeError.dispose();
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    _codeError.value = null;
    if (value.isNotEmpty && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _submit(BuildContext context) {
    final error = Validators.verificationCode(_code, length: _codeLength);
    _codeError.value = error;
    if (error != null) return;

    context
        .read<AuthCubit>()
        .onIntent(VerifyCodeRequested(email: _email, code: _code));
  }

  void _resend(BuildContext context) {
    _codeError.value = null;
    context.read<AuthCubit>().onIntent(ForgotPasswordRequested(_email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBackAppBar(title: AppStrings.passwordSectionTitle),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthCodeVerified) {
            Get.toNamed(
              CustomerRoutes.resetPassword,
              arguments: state.resetToken,
            );
          } else if (state is AuthPasswordResetEmailSent) {
            context.showSuccessSnackBar(AppStrings.verificationCodeResent);
          } else if (state is AuthFailed) {
            _codeError.value = state.failure.localizedMessage;
          }
        },
        builder: (context, state) {
          final isSubmitting = state is AuthLoading;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.space16),
              child: ValueListenableBuilder<String?>(
                valueListenable: _codeError,
                builder: (context, codeError, _) {
                  return Column(
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
                            if (index > 0)
                              const SizedBox(width: AppDimens.space16),
                            _OtpBox(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              enabled: !isSubmitting,
                              hasError: codeError != null,
                              onChanged: (value) =>
                                  _onDigitChanged(index, value),
                            ),
                          ],
                        ],
                      ),
                      if (codeError != null) ...[
                        const SizedBox(height: AppDimens.labelToFieldGap),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            codeError,
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.error),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
                                  style: AppTextStyles.bodyMedium,
                                ),
                                TextSpan(
                                  text: AppStrings.resendCodeAction,
                                  style: AppTextStyles.link,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A single digit box of the verification code.
class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.hasError,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final bool hasError;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimens.otpBoxWidth,
      height: AppDimens.otpBoxHeight,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTextStyles.titleLarge,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          // A `TextField` has no validator, so the error border has to be
          // driven explicitly from the shared code-level error state.
          enabledBorder: hasError ? _errorBorder : null,
          focusedBorder: hasError ? _errorBorder : null,
        ),
        onChanged: onChanged,
      ),
    );
  }

  static final OutlineInputBorder _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppDimens.radiusExtraSmall),
    borderSide: const BorderSide(color: AppColors.error),
  );
}
