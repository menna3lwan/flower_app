import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/core/utils/password_policy.dart';

import '../../support/localization_harness.dart';

/// [PasswordPolicy] is the single source of truth both [Validators.password]
/// and the live [PasswordRulesChecklist] read from — these tests pin down
/// exactly which passwords each rule accepts and rejects.
Future<void> _withLocale(WidgetTester tester, Locale locale) async {
  await pumpLocalized(
    tester,
    localizedApp(home: const SizedBox.shrink(), locale: locale),
  );
}

void main() {
  setUpAll(initializeTestLocalization);

  testWidgets('exposes exactly three rules: length, uppercase, number',
      (tester) async {
    await _withLocale(tester, const Locale('en'));

    expect(PasswordPolicy.rules(), hasLength(3));
  });

  group('isValid', () {
    testWidgets('rejects a password missing every rule', (tester) async {
      await _withLocale(tester, const Locale('en'));

      expect(PasswordPolicy.isValid(''), isFalse);
      expect(PasswordPolicy.isValid('abc'), isFalse);
    });

    testWidgets('rejects a password long enough but missing uppercase',
        (tester) async {
      await _withLocale(tester, const Locale('en'));

      expect(PasswordPolicy.isValid('password123'), isFalse);
    });

    testWidgets('rejects a password long enough but missing a number',
        (tester) async {
      await _withLocale(tester, const Locale('en'));

      expect(PasswordPolicy.isValid('Password'), isFalse);
    });

    testWidgets('accepts a password satisfying every rule', (tester) async {
      await _withLocale(tester, const Locale('en'));

      expect(PasswordPolicy.isValid('Password123'), isTrue);
    });
  });

  testWidgets('each rule reports its own pass/fail independently of the others',
      (tester) async {
    await _withLocale(tester, const Locale('en'));

    const value = 'password'; // long enough, lowercase only, no digit.
    final results = {
      for (final rule in PasswordPolicy.rules())
        rule.label: rule.isSatisfied(value),
    };

    expect(results.values.where((satisfied) => satisfied).length, 1);
  });
}
