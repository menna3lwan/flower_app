import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';


/// Shared text field: obscureText fields get an automatic show/hide toggle, and validation stays quiet until first blur or forceLiveValidation.
class AppTextField extends StatefulWidget {
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
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.fieldKey,
    this.forceLiveValidation = false,
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
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  /// Lets a parent imperatively re-run this field's validator (e.g. Confirm Password when Password changes).
  final GlobalKey<FormFieldState<String>>? fieldKey;

  /// Set after a failed Submit so every field, touched or not, starts validating live immediately.
  final bool forceLiveValidation;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  // Seeded once from widget.obscureText; never re-derived, or a rebuild would hide text the user chose to reveal.
  late bool _obscured = widget.obscureText;

  late final FocusNode _focusNode = FocusNode();
  bool _touched = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && !_touched) {
      setState(() => _touched = true);
    }
  }

  void _toggleObscured() => setState(() => _obscured = !_obscured);

  @override
  Widget build(BuildContext context) {
    final isPasswordField = widget.obscureText;
    final effectiveSuffixIcon =
        widget.suffixIcon ?? _buildVisibilityToggle(isPasswordField);
    final liveValidate = _touched || widget.forceLiveValidation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppDimens.labelToFieldGap),
        TextFormField(
          key: widget.fieldKey,
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: isPasswordField ? _obscured : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          autovalidateMode: widget.validator == null
              ? null
              : (liveValidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled),
          onChanged: widget.onChanged,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          maxLines: widget.maxLines,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatters,
          textCapitalization: widget.textCapitalization,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint ?? AppStrings.enterField(widget.label),
            prefixIcon: widget.prefixIcon,
            suffixIcon: effectiveSuffixIcon,
          ),
        ),
      ],
    );
  }

  Widget? _buildVisibilityToggle(bool isPasswordField) {
    if (!isPasswordField) return null;
    return IconButton(
      icon: Icon(
        _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: AppDimens.iconSize,
        color: AppColors.textSecondary,
      ),
      tooltip: _obscured ? AppStrings.showPassword : AppStrings.hidePassword,
      // Password fields are single-line, so this toggle needs no extra sizing beyond IconButton's default tap target.
      onPressed: widget.enabled ? _toggleObscured : null,
    );
  }
}
