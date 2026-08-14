import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/common/widgets/inputs/app_text_field.dart';
import 'package:customer_app/core/localization/app_strings.dart';

import '../../support/localization_harness.dart';

/// The label/box/error contract every auth form depends on. Asserting it
/// here — on the one shared widget — is what stops an individual screen
/// from quietly rearranging the three.
void main() {
  setUpAll(initializeTestLocalization);

  Future<GlobalKey<FormState>> pumpField(
    WidgetTester tester, {
    String? hint,
    String? Function(String?)? validator,
    Locale? locale,
  }) async {
    final formKey = GlobalKey<FormState>();
    await pumpLocalized(
      tester,
      localizedApp(
        locale: locale,
        home: Scaffold(
          body: Form(
            key: formKey,
            child: AppTextField(
              label: 'Email',
              hint: hint,
              validator: validator,
            ),
          ),
        ),
      ),
    );
    return formKey;
  }

  testWidgets('renders the label above the input box', (tester) async {
    await pumpField(tester, hint: 'Enter your email');

    expect(
      tester.getTopLeft(find.text('Email')).dy,
      lessThan(tester.getTopLeft(find.byType(TextFormField)).dy),
    );
  });

  testWidgets('renders the placeholder inside the box, not as the label',
      (tester) async {
    await pumpField(tester, hint: 'Enter your email');

    final labelBox = tester.getRect(find.text('Email'));
    final hintBox = tester.getRect(find.text('Enter your email'));
    final field = tester.getRect(find.byType(TextFormField));

    expect(labelBox.bottom, lessThanOrEqualTo(field.top));
    expect(hintBox.top, greaterThanOrEqualTo(field.top));
    expect(hintBox.bottom, lessThanOrEqualTo(field.bottom));
  });

  testWidgets('renders validation text below the box', (tester) async {
    final formKey = await pumpField(
      tester,
      hint: 'Enter your email',
      validator: (_) => 'Email is required',
    );

    formKey.currentState!.validate();
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('Email is required')).dy,
      greaterThan(tester.getBottomLeft(find.byType(TextFormField)).dy -
          tester.getSize(find.byType(TextFormField)).height),
    );
    // Label above, error below — never the other way round.
    expect(
      tester.getTopLeft(find.text('Email')).dy,
      lessThan(tester.getTopLeft(find.text('Email is required')).dy),
    );
  });

  testWidgets('falls back to a localized placeholder when none is given',
      (tester) async {
    await pumpField(tester, locale: const Locale('ar'));

    // Previously produced the hardcoded English `'Enter Email'.toLowerCase()`.
    expect(find.text(AppStrings.enterField('Email')), findsOneWidget);
    expect(find.text('enter email'), findsNothing);
  });
}
