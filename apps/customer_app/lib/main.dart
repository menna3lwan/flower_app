import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import './app.dart';
import './constants/app_assets.dart';
import './di/customer_app_injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupCustomerAppDependencies();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      fallbackLocale: const Locale('en'),
      path: AppAssets.translationsPath,
      child: const FlowerApp(),
    ),
  );
}
