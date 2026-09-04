import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../api/auth_api_service.dart';

/// `@module` for [AuthApiService], the one type Injectable can't annotate directly (Retrofit's factory-constructor pattern) — shares the app's single [Dio] instance.
@module
abstract class AuthApiModule {
  @lazySingleton
  AuthApiService authApiService(Dio dio) => AuthApiService(dio);
}
