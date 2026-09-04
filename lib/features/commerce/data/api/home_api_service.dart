import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:customer_app/core/network/api_endpoints.dart';

part 'home_api_service.g.dart';

/// Home's API surface (signature only, no parsing/business logic) — every path comes from [ApiEndpoints].
@RestApi()
abstract class HomeApiService {
  factory HomeApiService(Dio dio, {String? baseUrl}) = _HomeApiService;

  @GET(ApiEndpoints.homeSections)
  Future<Map<String, dynamic>> getHomeSections();
}
