import 'package:core/di/injector.dart';

/// The Rider app's dependency-injection **composition root**.
///
/// Mirrors `customer_app`'s `setupCustomerAppDependencies` — its own,
/// separate entry point into the shared `core` registrations. No Rider
/// feature has a `di/<feature>_injector.dart` yet (no Rider screens are
/// implemented), so this currently only wires the cross-cutting `core`
/// dependencies.
Future<void> setupRiderAppDependencies() async {
  await setupCoreDependencies();
}
