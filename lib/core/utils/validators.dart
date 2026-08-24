import '../localization/app_strings.dart';
import 'password_policy.dart';

abstract final class Validators {
  const Validators._();

  static final RegExp _emailPattern =
      RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');

  /// Alias kept in sync with [PasswordPolicy.minLength], the actual single source of truth for the rule.
  static const int minPasswordLength = PasswordPolicy.minLength;
  static const int minPhoneLength = 8;

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.emailRequired;
    if (!_emailPattern.hasMatch(value.trim())) return AppStrings.invalidEmail;
    return null;
  }

  /// Validates against [PasswordPolicy] — the same rule set [PasswordRulesChecklist] ticks off live, so the two can never disagree.
  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppStrings.passwordRequired;
    // Checked first so the common "too short" case keeps its precise message instead of the generic one.
    if (value.length < minPasswordLength) {
      return AppStrings.passwordTooShort(minPasswordLength);
    }
    if (!PasswordPolicy.isValid(value)) {
      return AppStrings.passwordRequirementsNotMet;
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.confirmPasswordRequired;
    }
    if (value != password) return AppStrings.passwordsDoNotMatch;
    return null;
  }

  static String? required(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? AppStrings.fieldRequired;
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.phoneRequired;
    if (value.trim().length < minPhoneLength) {
      return AppStrings.invalidPhoneNumber;
    }
    return null;
  }

  static String? verificationCode(String? value, {required int length}) {
    if (value == null || value.isEmpty) {
      return AppStrings.verificationCodeRequired;
    }
    if (value.length < length) return AppStrings.verificationCodeIncomplete;
    return null;
  }
}
