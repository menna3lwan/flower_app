import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

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
  /// Digit count for the verification code.
  ///
  /// Not declared by the live Auth service's Swagger contract (`otp` is an
  /// unconstrained string on `VerifyOtpCommand`) and not covered at all by
  /// the provided Postman collection, so there is no authoritative source
  /// to read a length from. Kept at the app's existing 4-digit convention
  /// as a single named constant — flagged in the delivery report as an
  /// unconfirmed assumption that should be verified with Backend rather
  /// than silently guessed differently.
  static const int _codeLength = 4;

  /// Local, client-side resend cooldown. The backend does not declare a
  /// mandated cooldown window for Forgot Password/OTP resend (only a
  /// generic 429 "too many requests" is documented), so this is a UX
  /// safeguard against accidental double-taps rather than a value read
  /// from the API contract.
  static const int _resendCooldownSeconds = 30;

  late final String _email;
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();
  final ValueNotifier<String?> _codeError = ValueNotifier(null);

  Timer? _cooldownTimer;
  int _secondsUntilResend = _resendCooldownSeconds;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    _email = arguments is String ? arguments : '';
    // A code was already sent by the Forgot Password screen right before
    // this screen was pushed, so the resend cooldown starts immediately.
    _startResendCooldown();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    _codeError.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startResendCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _secondsUntilResend = _resendCooldownSeconds);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsUntilResend <= 1) {
        timer.cancel();
        setState(() => _secondsUntilResend = 0);
      } else {
        setState(() => _secondsUntilResend--);
      }
    });
  }

  void _onCodeChanged(String value) {
    if (_codeError.value != null) _codeError.value = null;
  }

  void _submit(BuildContext context, {required bool isSubmitting}) {
    if (isSubmitting) return;
    final code = _pinController.text;
    final error = Validators.verificationCode(code, length: _codeLength);
    _codeError.value = error;
    if (error != null) return;

    context
        .read<AuthCubit>()
        .onIntent(VerifyCodeRequested(email: _email, code: code));
  }

  void _resend(BuildContext context, {required bool isSubmitting}) {
    if (isSubmitting || _secondsUntilResend > 0) return;
    _codeError.value = null;
    _pinController.clear();
    context.read<AuthCubit>().onIntent(ForgotPasswordRequested(_email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBackAppBar(title: AppStrings.passwordSectionTitle),
      body: MultiBlocListener(
        listeners: [
          // Submitting the code itself: success carries the resetToken
          // forward to Reset Password; failure reports "wrong/expired
          // code" specifically.
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.verifyOtpState != current.verifyOtpState,
            listener: (context, state) {
              final verifyOtpState = state.verifyOtpState;
              if (verifyOtpState.isSuccess) {
                Get.toNamed(
                  CustomerRoutes.resetPassword,
                  arguments: verifyOtpState.data,
                );
              } else if (verifyOtpState.isFailure) {
                _codeError.value = verifyOtpState.failure!.verifyOtpMessage;
              }
            },
          ),
          // The "Resend" action reuses ForgotPasswordRequested on this
          // same Cubit instance — tracked as its own field
          // (forgotPasswordState) rather than being folded into
          // verifyOtpState, so a resend failure is reported with its own
          // "couldn't send the code" wording instead of "wrong code".
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.forgotPasswordState != current.forgotPasswordState,
            listener: (context, state) {
              final forgotPasswordState = state.forgotPasswordState;
              if (forgotPasswordState.isSuccess) {
                context.showInfoSnackBar(AppStrings.verificationCodeResent);
                _startResendCooldown();
              } else if (forgotPasswordState.isFailure) {
                _codeError.value =
                    forgotPasswordState.failure!.forgotPasswordMessage;
              }
            },
          ),
        ],
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isSubmitting = state.verifyOtpState.isLoading ||
                state.forgotPasswordState.isLoading;
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
                      Center(
                        child: _OtpPinInput(
                          controller: _pinController,
                          focusNode: _pinFocusNode,
                          length: _codeLength,
                          enabled: !isSubmitting,
                          hasError: codeError != null,
                          onChanged: _onCodeChanged,
                          onCompleted: (_) =>
                              _submit(context, isSubmitting: isSubmitting),
                        ),
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
                        onPressed: () =>
                            _submit(context, isSubmitting: isSubmitting),
                      ),
                      const SizedBox(height: AppDimens.space16),
                      Builder(
                        builder: (context) {
                          final onCooldown = _secondsUntilResend > 0;
                          final resendDisabled = isSubmitting || onCooldown;
                          return Center(
                            child: GestureDetector(
                              onTap: resendDisabled
                                  ? null
                                  : () => _resend(context,
                                      isSubmitting: isSubmitting),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${AppStrings.resendCodePrefix} ',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                    TextSpan(
                                      text: onCooldown
                                          ? AppStrings.resendCodeCountdown(
                                              _secondsUntilResend)
                                          : AppStrings.resendCodeAction,
                                      style: resendDisabled
                                          ? AppTextStyles.link.copyWith(
                                              color: AppColors.textSecondary,
                                              decoration: TextDecoration.none,
                                            )
                                          : AppTextStyles.link,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          );
          },
        ),
      ),
    );
  }
}

/// The Pinput-based verification code field, themed per interaction state
/// (default / focused / filled / error / disabled) from the app's design
/// tokens instead of Pinput's own defaults.
class _OtpPinInput extends StatelessWidget {
  const _OtpPinInput({
    required this.controller,
    required this.focusNode,
    required this.length,
    required this.enabled,
    required this.hasError,
    required this.onChanged,
    required this.onCompleted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int length;
  final bool enabled;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;

  BoxDecoration _boxDecoration(Color borderColor, {Color? fillColor}) {
    return BoxDecoration(
      color: fillColor ?? AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
      border: Border.all(color: borderColor, width: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.titleLarge;
    final boxConstraints = const BoxConstraints(
      minWidth: AppDimens.otpBoxWidth,
      minHeight: AppDimens.otpBoxHeight,
    );

    final defaultTheme = PinTheme(
      width: AppDimens.otpBoxWidth,
      height: AppDimens.otpBoxHeight,
      textStyle: baseStyle,
      decoration: _boxDecoration(AppColors.divider),
      constraints: boxConstraints,
    );

    final focusedTheme = defaultTheme.copyWith(
      decoration: _boxDecoration(AppColors.primary),
    );

    final submittedTheme = defaultTheme.copyWith(
      decoration: _boxDecoration(
        AppColors.primary,
        fillColor: AppColors.primaryLight,
      ),
    );

    final errorTheme = defaultTheme.copyWith(
      decoration: _boxDecoration(AppColors.error),
    );

    final disabledTheme = defaultTheme.copyWith(
      textStyle: baseStyle.copyWith(color: AppColors.textHint),
      decoration: _boxDecoration(
        AppColors.divider,
        fillColor: AppColors.background,
      ),
    );

    return Pinput(
      length: length,
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      enabled: enabled,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      defaultPinTheme: defaultTheme,
      focusedPinTheme: focusedTheme,
      submittedPinTheme: submittedTheme,
      disabledPinTheme: disabledTheme,
      errorPinTheme: hasError ? errorTheme : null,
      forceErrorState: hasError,
      separatorBuilder: (_) => const SizedBox(width: AppDimens.space16),
      showCursor: true,
      cursor: Container(
        width: 2,
        height: AppDimens.space24,
        color: AppColors.primary,
      ),
      onChanged: onChanged,
      onCompleted: onCompleted,
    );
  }
}
