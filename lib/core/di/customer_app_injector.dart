import 'package:customer_app/core/di/injector.dart';

import './injectable_injector.dart';

/// Boots core infrastructure first, then every Injectable-annotated class app-wide via `configureDependencies()`.
Future<void> setupCustomerAppDependencies() async {
  await setupCoreDependencies();
  await configureDependencies(sl);
}
