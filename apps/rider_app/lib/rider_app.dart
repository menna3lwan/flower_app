import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:design_system/theme/app_theme.dart';
import 'routing/rider_pages.dart';
import 'rider_foundation_preview_screen.dart';

/// Root widget of the Rider app. Uses [GetMaterialApp] (rather than
/// [MaterialApp]) purely for GetX's navigation/dialog/snackbar utilities —
/// no GetX state management, state stays in Cubits per the MVI rule. This
/// mirrors `customer_app`'s `FlowerApp` but is a completely separate
/// widget tree/binary — the two apps never share a running instance.
///
/// `home` currently points at [RiderFoundationPreviewScreen] instead of a
/// named initial route: [RiderPages.pages] is intentionally empty (no
/// Rider screens are implemented yet). Once Onboarding is built, switch
/// to `initialRoute: RiderRoutes.onboarding` and remove `home`.
class RiderApp extends StatelessWidget {
  const RiderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flowery Rider',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      getPages: RiderPages.pages,
      home: const RiderFoundationPreviewScreen(),
    );
  }
}
