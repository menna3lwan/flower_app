import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/foundation_preview_screen.dart';

import 'support/localization_harness.dart';

void main() {
  // The screen renders `AppStrings` values, which resolve `.tr()` against
  // an EasyLocalization context — pumping it into a bare MaterialApp threw.
  setUpAll(initializeTestLocalization);

  testWidgets('FoundationPreviewScreen renders the design-system sections',
      (tester) async {
    await pumpLocalized(
      tester,
      localizedApp(home: const FoundationPreviewScreen()),
    );

    expect(find.text('Core + Common + Assets'), findsOneWidget);
    expect(find.text('Primary button'), findsOneWidget);
    expect(find.text('Secondary button'), findsOneWidget);
  });
}
