import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/network/api_endpoints.dart';

part 'auth_api_service.g.dart';

/// Auth's complete API surface (signatures only, no parsing/business logic); every path comes from [ApiEndpoints], the single source of truth for Gateway routes.
@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String? baseUrl}) = _AuthApiService;

  @POST(ApiEndpoints.userLogin)
  Future<Map<String, dynamic>> login(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.register)
  Future<Map<String, dynamic>> signUp(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.forgotPassword)
  Future<Map<String, dynamic>> forgotPassword(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiEndpoints.verifyOtp)
  Future<Map<String, dynamic>> verifyOtp(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.resetPassword)
  Future<Map<String, dynamic>> resetPassword(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiEndpoints.refreshToken)
  Future<Map<String, dynamic>> refreshToken(
    @Body() Map<String, dynamic> body,
  );
}
