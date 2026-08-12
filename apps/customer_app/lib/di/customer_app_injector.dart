import 'package:core/di/injector.dart';

/// The Customer app's dependency-injection **composition root**.
///
/// This is the one place that decides which GetIt registrations run, and
/// in what order, for `customer_app` specifically — it calls the shared
/// `core` package's cross-cutting registrations, then (as each feature
/// gains a `di/<feature>_injector.dart`) each feature's own registrar.
/// `rider_app` has its own separate composition root
/// (`rider_app/lib/di/rider_app_injector.dart`); the two are never
/// merged into one global configuration.
Future<void> setupCustomerAppDependencies() async {
  await setupCoreDependencies();
  // Feature registrars are appended here as each feature gains its own
  // `di/<feature>_injector.dart` — none exist yet (auth/catalog/home are
  // still domain+data scaffolding without wired presentation).
}
