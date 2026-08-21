import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/core/theme/app_theme.dart';

const List<Locale> _supportedLocales = [Locale('en'), Locale('ar')];

/// Prepares `easy_localization` for a widget test.

/// EasyLocalization persists the active locale via `shared_preferences`,
/// whose platform channel has no implementation under `flutter_test` —
/// calling `ensureInitialized()` without this stub throws
/// `MissingPluginException` in `setUpAll`, before a single widget is
/// pumped.
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

/// Its controller keeps state between tests: after the first widget test
/// in a file, a fresh `EasyLocalization` renders an empty placeholder and
/// `pumpAndSettle()` returns before the translations arrive, so every
/// `find.text` after the first test matched nothing. Running the pump
/// through [WidgetTester.runAsync] lets the real bundle read complete.
Future<void> pumpLocalized(WidgetTester tester, Widget app) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(app);
    await Future<void>.delayed(const Duration(milliseconds: 50));
  });
  await tester.pumpAndSettle();
}

/// Grows the test surface so a tall form (Sign Up has six fields) lays out
/// fully instead of overflowing the default 800x600 viewport, which makes
/// position assertions meaningless. Restored at the end of the test.
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
