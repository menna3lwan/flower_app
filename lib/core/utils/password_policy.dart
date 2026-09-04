import 'package:customer_app/core/localization/app_strings.dart';

/// One password requirement, evaluated live against whatever the user has typed so far.
class PasswordRule {
  const PasswordRule({required this.label, required this.isSatisfied});

  /// Localized rule text, e.g. "At least 6 characters".
  final String label;

  /// Returns whether [value] currently satisfies this rule.
  final bool Function(String value) isSatisfied;
}

/// The single confirmed password policy (mirrors `AppStrings.resetPasswordSubtitle`'s promised copy) — [Validators.password] and [PasswordRulesChecklist] both read from [rules] so they can never drift apart.
abstract final class PasswordPolicy {
  const PasswordPolicy._();

  static const int minLength = 6;

  static List<PasswordRule> rules() => [
        PasswordRule(
          label: AppStrings.passwordRuleMinLength,
          isSatisfied: (value) => value.length >= minLength,
        ),
        PasswordRule(
          label: AppStrings.passwordRuleUppercase,
          isSatisfied: (value) => value.contains(RegExp('[A-Z]')),
        ),
        PasswordRule(
          label: AppStrings.passwordRuleNumber,
          isSatisfied: (value) => value.contains(RegExp('[0-9]')),
        ),
      ];

  /// Whether [value] satisfies every rule in [rules].
  static bool isValid(String value) =>
      rules().every((rule) => rule.isSatisfied(value));
}
