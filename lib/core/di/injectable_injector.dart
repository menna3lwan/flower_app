import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injectable_injector.config.dart';

/// Single app-wide Injectable entry point; every `@injectable`/`@LazySingleton`/`@module` class gets wired here — core infra stays on its own manual bootstrap.
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies(GetIt getIt) async {
  getIt.init();
}
