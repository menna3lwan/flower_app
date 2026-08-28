import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/localization/current_language.dart';
import './core/routing/customer_pages.dart';
import './core/routing/customer_routes.dart';
import 'package:customer_app/core/theme/app_theme.dart';

class FlowerApp extends StatelessWidget {
  const FlowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Kept in sync with the active locale so the network layer can send Accept-Language without a BuildContext.
    CurrentLanguage.code = context.locale.languageCode;

    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      getPages: CustomerPages.pages,
      // SplashView was built but never reachable before; starting here is the routing fix that makes it run.
      initialRoute: CustomerRoutes.productDetails,
    );
  }
}
