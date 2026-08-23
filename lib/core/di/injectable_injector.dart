import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injectable_injector.config.dart';

/// Injectable-generated registrations for the Auth module — every class
/// under `features/auth/**` annotated `@injectable`/`@LazySingleton`/
/// `@module` gets wired into [sl] here instead of the old hand-written
/// `core/di/auth_injector.dart` list (retired — see git history).
///
/// Core-level dependencies ([Dio], `SecureStorageService`, ...) stay on
/// the existing manual `core/di/injector.dart` bootstrap; this only
/// covers the Auth module, per this refactor's "one module: auth" scope.
///
/// `initializerName: 'init'` + `asExtension: true` are set explicitly so
/// the generated shape matches `injectable_injector.config.dart`'s
/// hand-written stand-in exactly (`extension GetItInjectableX on GetIt {
/// GetIt init() { ... } }`) — running `dart run build_runner build
/// --delete-conflicting-outputs` regenerates that file for real without
/// requiring any change here.
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureAuthDependencies(GetIt getIt) async {
  getIt.init();
}
