import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './constants/app_strings.dart';
import './routing/customer_pages.dart';
import 'package:design_system/theme/app_theme.dart';
import './foundation_preview_screen.dart';

/// Root widget. Uses [GetMaterialApp] (rather than [MaterialApp]) purely
/// for GetX's navigation/dialog/snackbar utilities — no GetX state
/// management is used anywhere; state stays in Cubits per the MVI rule.
///
/// `home` currently points at [FoundationPreviewScreen] instead of a
/// named initial route: [CustomerPages.pages] is intentionally empty at this
/// stage (see that file's doc comment), so there is nothing yet for
/// `initialRoute` to resolve. Once the first feature is wired, switch to
/// `initialRoute: CustomerRoutes.splash` / `CustomerRoutes.login` and remove
/// `home`.
class FlowerApp extends StatelessWidget {
  const FlowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      getPages: CustomerPages.pages,
      home: const FoundationPreviewScreen(),
    );
  }
}
