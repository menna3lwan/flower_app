import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:customer_app/foundation_preview_screen.dart';

void main() {
  testWidgets('FoundationPreviewScreen renders the design-system sections', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: FoundationPreviewScreen()),
    );

    expect(find.text('Core + Common + Assets'), findsOneWidget);
    expect(find.text('Primary button'), findsOneWidget);
    expect(find.text('Secondary button'), findsOneWidget);
  });
}
