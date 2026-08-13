import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.enabled = true,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    super.key,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;
  final bool enabled;

  final List<TextInputFormatter>? inputFormatters;

  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          enabled: enabled,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: hint ?? 'Enter $label'.toLowerCase(),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
