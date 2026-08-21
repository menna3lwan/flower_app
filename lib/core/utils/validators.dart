import '../localization/app_strings.dart';
import 'password_policy.dart';

abstract final class Validators {
  const Validators._();

  static final RegExp _emailPattern =
      RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');

  /// Kept in sync with [PasswordPolicy.minLength] — [PasswordPolicy] is the
  /// single source of truth for the actual rule; this alias just avoids
  /// touching every call site that already reads `Validators.minPasswordLength`.
  static const int minPasswordLength = PasswordPolicy.minLength;
  static const int minPhoneLength = 8;

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.emailRequired;
    if (!_emailPattern.hasMatch(value.trim())) return AppStrings.invalidEmail;
    return null;
  }

  /// Validates against [PasswordPolicy] — the exact same rule set the live
  /// [PasswordRulesChecklist] ticks off on screen, so a password that shows
  /// all-green checkmarks always passes here too, and vice versa.
  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppStrings.passwordRequired;
    // Checked first, and reported with its own specific message, so the
    // most common failure (just too short) keeps its precise wording
    // instead of collapsing into the generic "doesn't meet requirements".
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
