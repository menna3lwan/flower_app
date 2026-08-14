import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/utils/validators.dart';

import '../../support/localization_harness.dart';

/// Pumps a throwaway widget purely to bring an `EasyLocalization` context
/// into scope, since `AppStrings` getters resolve `.tr()` against it.
Future<void> _withLocale(WidgetTester tester, Locale locale) async {
  await pumpLocalized(
    tester,
    localizedApp(home: const SizedBox.shrink(), locale: locale),
  );
}

void main() {
  setUpAll(initializeTestLocalization);

  group('email', () {
    testWidgets('distinguishes missing from malformed', (tester) async {
      await _withLocale(tester, const Locale('en'));

      expect(Validators.email(null), AppStrings.emailRequired);
      expect(Validators.email(''), AppStrings.emailRequired);
      expect(Validators.email('   '), AppStrings.emailRequired);
      expect(Validators.email('not-an-email'), AppStrings.invalidEmail);
      expect(Validators.email('missing@tld'), AppStrings.invalidEmail);

      // The two cases must not collapse into one message — that was the
      // bug: every email problem rendered as "This Email is not valid".
      expect(AppStrings.emailRequired, isNot(AppStrings.invalidEmail));
    });

    testWidgets('accepts valid addresses, including long TLDs', (tester) async {
      await _withLocale(tester, const Locale('en'));

      expect(Validators.email('test@flowery.com'), isNull);
      expect(Validators.email('  test@flowery.com  '), isNull);
      expect(Validators.email('first.last@sub.example.co.uk'), isNull);
      expect(Validators.email('curator@museum.museum'), isNull);
    });
  });

  group('password', () {
    testWidgets('reports empty and too-short separately', (tester) async {
      await _withLocale(tester, const Locale('en'));

      expect(Validators.password(null), AppStrings.passwordRequired);
      expect(Validators.password(''), AppStrings.passwordRequired);
      expect(
        Validators.password('abc'),
        AppStrings.passwordTooShort(Validators.minPasswordLength),
      );
      expect(Validators.password('Password123'), isNull);
    });

    testWidgets('interpolates the minimum length into the message',
        (tester) async {
      await _withLocale(tester, const Locale('en'));

      expect(
        AppStrings.passwordTooShort(Validators.minPasswordLength),
        contains('${Validators.minPasswordLength}'),
      );
    });
  });

  group('confirmPassword', () {
    testWidgets('requires a value and an exact match', (tester) async {
      await _withLocale(tester, const Locale('en'));

      expect(
        Validators.confirmPassword(null, 'Password123'),
        AppStrings.confirmPasswordRequired,
      );
      expect(
        Validators.confirmPassword('Password124', 'Password123'),
        AppStrings.passwordsDoNotMatch,
      );
      expect(Validators.confirmPassword('Password123', 'Password123'), isNull);
    });
  });

  group('phone', () {
    testWidgets('reports empty and too-short separately', (tester) async {
      await _withLocale(tester, const Locale('en'));

      expect(Validators.phone(''), AppStrings.phoneRequired);
      expect(Validators.phone('123'), AppStrings.invalidPhoneNumber);
      expect(Validators.phone('01012345678'), isNull);
    });
  });

  group('verificationCode', () {
    testWidgets('reports empty and incomplete separately', (tester) async {
      await _withLocale(tester, const Locale('en'));

      expect(
        Validators.verificationCode('', length: 4),
        AppStrings.verificationCodeRequired,
      );
      expect(
        Validators.verificationCode('12', length: 4),
        AppStrings.verificationCodeIncomplete,
      );
      expect(Validators.verificationCode('1234', length: 4), isNull);
    });
  });

  group('required', () {
    testWidgets('uses the caller-supplied message when given', (tester) async {
      await _withLocale(tester, const Locale('en'));

      expect(Validators.required(''), AppStrings.fieldRequired);
      expect(
        Validators.required('', message: AppStrings.firstNameRequired),
        AppStrings.firstNameRequired,
      );
      expect(Validators.required('Nour'), isNull);
    });
  });

  testWidgets('every validation message is localized, not hardcoded English',
      (tester) async {
    await _withLocale(tester, const Locale('ar'));

    // In Arabic each message must differ from its English counterpart and
    // contain Arabic script — a validator returning a raw English literal
    // would fail both checks.
    final arabicMessages = <String?>[
      Validators.email(''),
      Validators.email('nope'),
      Validators.password(''),
      Validators.password('abc'),
      Validators.confirmPassword('', 'x'),
      Validators.confirmPassword('y', 'x'),
      Validators.phone(''),
      Validators.phone('12'),
      Validators.verificationCode('', length: 4),
      Validators.required(''),
    ];

    final arabicScript = RegExp(r'[؀-ۿ]');
    for (final message in arabicMessages) {
      expect(message, isNotNull);
      expect(
        arabicScript.hasMatch(message!),
        isTrue,
        reason: 'Expected Arabic text but got "$message"',
      );
    }
  });
}
