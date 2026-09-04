import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/common/widgets/inputs/password_rules_checklist.dart';
import 'package:customer_app/core/localization/app_strings.dart';

import '../../support/localization_harness.dart';

void main() {
  setUpAll(initializeTestLocalization);

  Future<TextEditingController> pumpChecklist(WidgetTester tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await pumpLocalized(
      tester,
      localizedApp(
        home: Scaffold(
          body: PasswordRulesChecklist(controller: controller),
        ),
      ),
    );
    return controller;
  }

  testWidgets('every rule starts unmet for an empty password', (tester) async {
    final controller = await pumpChecklist(tester);
    controller.text = '';
    await tester.pump();

    expect(find.byIcon(Icons.check_circle), findsNothing);
    expect(find.byIcon(Icons.circle_outlined), findsNWidgets(3));
  });

  testWidgets('ticks rules on live, one at a time, as they become satisfied',
      (tester) async {
    final controller = await pumpChecklist(tester);

    controller.text = 'abcdef'; // satisfies length only.
    await tester.pump();
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    controller.text = 'Abcdef'; // + uppercase.
    await tester.pump();
    expect(find.byIcon(Icons.check_circle), findsNWidgets(2));

    controller.text = 'Abcdef1'; // + number: all three.
    await tester.pump();
    expect(find.byIcon(Icons.check_circle), findsNWidgets(3));
    expect(find.byIcon(Icons.circle_outlined), findsNothing);
  });

  testWidgets('un-ticks a rule the instant it stops being satisfied',
      (tester) async {
    final controller = await pumpChecklist(tester);

    controller.text = 'Abcdef1';
    await tester.pump();
    expect(find.byIcon(Icons.check_circle), findsNWidgets(3));

    controller.text = 'Abcdef'; // remove the digit again.
    await tester.pump();
    expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
  });

  testWidgets('renders the localized rule labels', (tester) async {
    await pumpChecklist(tester);

    expect(find.text(AppStrings.passwordRuleMinLength), findsOneWidget);
    expect(find.text(AppStrings.passwordRuleUppercase), findsOneWidget);
    expect(find.text(AppStrings.passwordRuleNumber), findsOneWidget);
  });
}
