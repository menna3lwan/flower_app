import 'package:customer_app/core/di/injector.dart';

import './injectable_injector.dart';

/// Boots the whole app's dependency graph: core-level dependencies first
/// (Dio, storage, network info — `injector.dart`, still hand-registered),
/// then the Auth module's Injectable-generated registrations
/// (`injectable_injector.dart`), which depend on some of those core ones
/// (e.g. [AuthApiModule] needs [Dio] already registered).
Future<void> setupCustomerAppDependencies() async {
  await setupCoreDependencies();
  await configureAuthDependencies(sl);
}
