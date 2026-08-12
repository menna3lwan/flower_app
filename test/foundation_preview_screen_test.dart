import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flower_app/core/di/injector.dart';
import 'package:flower_app/core/localization/app_localizations_delegate.dart';
import 'package:flower_app/core/localization/supported_locales.dart';
import 'package:flower_app/foundation_preview_screen.dart';
import 'package:get/get.dart';

void main() {
  setUpAll(() async {
    await setupCoreDependencies();
  });

  // Wrapped in GetMaterialApp, matching lib/app.dart, since the locale toggle applies via `Get.updateLocale`.
  Widget wrap(Widget child) {
    return GetMaterialApp(
      locale: SupportedLocales.english,
      supportedLocales: SupportedLocales.all,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    );
  }

  testWidgets('FoundationPreviewScreen renders the design-system sections', (tester) async {
    await tester.pumpWidget(wrap(const FoundationPreviewScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Core + Common + Assets'), findsOneWidget);
    expect(find.text('Primary button'), findsOneWidget);
    expect(find.text('Secondary button'), findsOneWidget);
  });

  testWidgets('Switching to Arabic flips text direction to RTL', (tester) async {
    await tester.pumpWidget(wrap(const FoundationPreviewScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(FoundationPreviewScreen));
    expect(Directionality.of(context), TextDirection.rtl);
    expect(find.text('النواة + المشترك + الأصول'), findsOneWidget);
  });
}
