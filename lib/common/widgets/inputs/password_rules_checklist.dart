import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';
import 'package:customer_app/core/utils/password_policy.dart';

/// Live password-requirements checklist.
///
/// Listens to [controller] and re-evaluates every [PasswordPolicy] rule on
/// each keystroke, ticking rules on/off as the user types. The rule list
/// itself is never duplicated here — it always comes from [PasswordPolicy],
/// the same source [Validators.password] validates against, so the
/// checklist can never show a rule as satisfied that submit-time validation
/// would still reject.
///
/// Used only on screens where a *new* password is being created (Sign Up,
/// Reset Password) — not on Login, where the password already exists and
/// re-stating creation rules would be meaningless.
class PasswordRulesChecklist extends StatelessWidget {
  const PasswordRulesChecklist({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final value = controller.text;
        final rules = PasswordPolicy.rules();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < rules.length; i++)
              Padding(
                padding: EdgeInsets.only(
                  top: i == 0 ? 0 : AppDimens.space4,
                ),
                child: _PasswordRuleRow(
                  label: rules[i].label,
                  isSatisfied: rules[i].isSatisfied(value),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PasswordRuleRow extends StatelessWidget {
  const _PasswordRuleRow({required this.label, required this.isSatisfied});

  final String label;
  final bool isSatisfied;

  @override
  Widget build(BuildContext context) {
    final color = isSatisfied ? AppColors.success : AppColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isSatisfied ? Icons.check_circle : Icons.circle_outlined,
          size: AppDimens.iconSizeSmall,
          color: color,
        ),
        const SizedBox(width: AppDimens.space8),
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
