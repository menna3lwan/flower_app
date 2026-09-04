import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/core/theme/app_theme.dart';

const List<Locale> _supportedLocales = [Locale('en'), Locale('ar')];

/// Prepares `easy_localization` for a widget test.

/// Stubs `shared_preferences`, whose platform channel has no implementation under `flutter_test` and would otherwise throw in `setUpAll`.
Future<void> initializeTestLocalization() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/shared_preferences'),
    (call) async => call.method == 'getAll' ? <String, Object>{} : null,
  );
  await EasyLocalization.ensureInitialized();
}

/// Pumps [app] and lets `easy_localization`'s asset load actually finish.

/// Runs the pump through [WidgetTester.runAsync] so the real translation bundle finishes loading before assertions run.
Future<void> pumpLocalized(WidgetTester tester, Widget app) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(app);
    await Future<void>.delayed(const Duration(milliseconds: 50));
  });
  await tester.pumpAndSettle();
}

/// Grows the test surface so a tall form (Sign Up's six fields) lays out fully instead of overflowing the default viewport.
void useTallSurface(WidgetTester tester, {Size size = const Size(1080, 2400)}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget localizedApp({required Widget home, Locale? locale}) {
  return EasyLocalization(
    supportedLocales: _supportedLocales,
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    startLocale: locale,
    child: Builder(
      builder: (context) => MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppTheme.light,
        home: home,
      ),
    ),
  );
}
