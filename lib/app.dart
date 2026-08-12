import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/localization/app_localizations_delegate.dart';
import 'core/localization/supported_locales.dart';
import 'core/routing/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'foundation_preview_screen.dart';

/// Root widget; uses [GetMaterialApp] only for GetX navigation/dialog/locale utilities, never state management.
class FlowerApp extends StatelessWidget {
  const FlowerApp({required this.initialLocale, super.key});

  final Locale initialLocale;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flowery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      getPages: AppPages.pages,
      locale: initialLocale,
      fallbackLocale: SupportedLocales.fallback,
      supportedLocales: SupportedLocales.all,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const FoundationPreviewScreen(),
    );
  }
}
