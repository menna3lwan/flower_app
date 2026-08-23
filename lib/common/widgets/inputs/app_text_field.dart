import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

/// Shared text field used across every form in the app.
///
/// Password fields get a show/hide visibility toggle for free: pass
/// `obscureText: true` and, as long as no explicit [suffixIcon] is
/// supplied, a trailing eye icon is injected automatically. The toggle
/// only flips how the existing text renders — it never touches
/// [controller]'s value or selection, so the typed password and cursor
/// position survive a tap untouched. This is implemented once, here, so no
/// screen (Login, Sign Up, Reset Password, ...) needs its own copy of the
/// same toggle logic.
///
/// Live validation: a field stays quiet (no error shown) until the user
/// leaves it once (focus lost) — matching "don't show errors before the
/// user has interacted with the field." After that first blur, or once
/// [forceLiveValidation] is set (a screen sets this after a failed Submit
/// press, so every field — touched or not — starts reporting live from
/// then on), the field validates on every keystroke and its error clears
/// the instant the input becomes valid again. This lives here, once,
/// rather than being re-implemented per screen.
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

  /// Lets a parent imperatively re-run just this field's validator (e.g.
  /// Sign Up re-checking Confirm Password the moment Password changes) —
  /// see `sign_up_view.dart`/`reset_password_view.dart`.
  final GlobalKey<FormFieldState<String>>? fieldKey;

  /// Set by the parent Form after a failed Submit press so every field —
  /// including ones the user never touched — starts live-validating
  /// immediately, instead of only ones they've already visited.
  final bool forceLiveValidation;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  // Seeded once from widget.obscureText and never re-derived from it again
  // — otherwise a parent rebuild (e.g. on every keystroke, which is exactly
  // what typing does) would reset text the user chose to reveal back to
  // hidden on the very next frame.
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
      // A password field is always single-line, so this toggle is the only
      // interactive control sharing the field's 56px height — no extra
      // padding/sizing needed beyond IconButton's own default tap target.
      onPressed: widget.enabled ? _toggleObscured : null,
    );
  }
}
