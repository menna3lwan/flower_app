import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../api/auth_api_service.dart';

/// Injectable `@module` for the one Auth-module type that can't carry its
/// own `@injectable` constructor annotation: [AuthApiService] is
/// constructed via a factory constructor (Retrofit's generated-class
/// pattern), not a plain class Injectable can annotate directly.
///
/// [Dio] itself stays registered the existing way, in
/// `core/di/injector.dart`'s `setupCoreDependencies()` — this module only
/// adds one more registration on top of it, so Auth's Retrofit service
/// shares the exact same [Dio] instance (and therefore the exact same
/// interceptors: auth header, Accept-Language, logging) as everything
/// else in the app.
@module
abstract class AuthApiModule {
  @lazySingleton
  AuthApiService authApiService(Dio dio) => AuthApiService(dio);
}
