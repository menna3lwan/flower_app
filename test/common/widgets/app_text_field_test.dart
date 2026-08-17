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

  group('password visibility toggle', () {
    Future<void> pumpPasswordField(
      WidgetTester tester, {
      TextEditingController? controller,
    }) async {
      await pumpLocalized(
        tester,
        localizedApp(
          home: Scaffold(
            body: AppTextField(
              label: 'Password',
              controller: controller,
              obscureText: true,
            ),
          ),
        ),
      );
    }

    testWidgets('is not shown for a non-password field', (tester) async {
      await pumpField(tester, hint: 'Enter your email');

      expect(find.byIcon(Icons.visibility_outlined), findsNothing);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
    });

    testWidgets('starts obscured with the "show" icon visible',
        (tester) async {
      await pumpPasswordField(tester);

      final field = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(field.obscureText, isTrue);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('tapping the icon reveals the password and flips the icon',
        (tester) async {
      await pumpPasswordField(tester);

      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

      final field = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(field.obscureText, isFalse);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
    });

    testWidgets('tapping twice returns to obscured', (tester) async {
      await pumpPasswordField(tester);

      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      final field = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(field.obscureText, isTrue);
    });

    testWidgets('toggling does not change the typed value or cursor offset',
        (tester) async {
      final controller = TextEditingController(text: 'Password123');
      addTearDown(controller.dispose);
      await pumpPasswordField(tester, controller: controller);

      controller.selection =
          const TextSelection.collapsed(offset: 'Password123'.length);

      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

      expect(controller.text, 'Password123');
      expect(controller.selection.baseOffset, 'Password123'.length);
    });

    testWidgets('an explicit suffixIcon suppresses the auto toggle',
        (tester) async {
      await pumpLocalized(
        tester,
        localizedApp(
          home: Scaffold(
            body: AppTextField(
              label: 'Password',
              obscureText: true,
              suffixIcon: const Icon(Icons.lock),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
    });
  });
}

extension on TextFormField {
   get obscureText => null;
}
