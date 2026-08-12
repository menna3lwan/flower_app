import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injector.dart';
import 'core/localization/locale_controller.dart';
import 'features/auth/di/auth_injector.dart';
import 'features/catalog/di/catalog_injector.dart';
import 'features/home/di/home_injector.dart';
import 'features/splash/di/splash_injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bootstrap order matters: catalog must run before home, which resolves `CatalogRepository`.
  await setupCoreDependencies();
  setupCatalogDependencies();
  setupAuthDependencies();
  setupHomeDependencies();
  setupSplashDependencies();

  final initialLocale = await sl<LocaleController>().loadPersistedLocale();
  runApp(FlowerApp(initialLocale: initialLocale));
}
