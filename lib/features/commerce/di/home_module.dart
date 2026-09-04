import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../data/api/home_api_service.dart';

/// `@module` for [HomeApiService], the one type Injectable can't annotate directly (Retrofit's factory-constructor pattern) — shares the app's single [Dio] instance.
@module
abstract class HomeApiModule {
  @lazySingleton
  HomeApiService homeApiService(Dio dio) => HomeApiService(dio);
}
