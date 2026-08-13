import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:customer_app/core/localization/app_strings.dart';
import './core/routing/customer_pages.dart';
import './core/routing/customer_routes.dart';
import 'package:customer_app/core/theme/app_theme.dart';

class FlowerApp extends StatelessWidget {
  const FlowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      getPages: CustomerPages.pages,
      // SplashView is a real, already-built screen (branded launch state
      // + redirect to Login) that was simply never reachable before —
      // starting here instead of Login is the routing fix that makes it
      // actually run.
      initialRoute: CustomerRoutes.splash,
    );
  }
}
