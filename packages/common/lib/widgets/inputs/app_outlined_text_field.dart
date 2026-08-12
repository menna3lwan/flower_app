import 'package:flutter/material.dart';

import 'package:design_system/constants/app_colors.dart';
import 'package:design_system/constants/app_dimens.dart';
import 'package:design_system/theme/app_text_styles.dart';
import 'package:flutter/services.dart';
/// overridden below.
class AppOutlinedTextField extends StatelessWidget {
  const AppOutlinedTextField({
    required this.label,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.enabled = true,
    super.key,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      enabled: enabled,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: false,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space16,
          vertical: AppDimens.space12,
        ),

        labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.gray),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.placeholderGray),
      ),
    );
  }
}
