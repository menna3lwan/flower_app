import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/network/api_endpoints.dart';
import '../data/models/auth_api_envelope.dart';

part 'auth_api_service.g.dart';

/// Auth's complete API surface (signatures only, no parsing/business logic); every path comes from [ApiEndpoints], the single source of truth for Gateway routes.
@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String? baseUrl}) = _AuthApiService;

  @POST(ApiEndpoints.userLogin)
  Future<AuthApiEnvelope> login(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.register)
  Future<AuthApiEnvelope> signUp(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.forgotPassword)
  Future<AuthApiEnvelope> forgotPassword(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiEndpoints.verifyOtp)
  Future<AuthApiEnvelope> verifyOtp(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.resetPassword)
  Future<AuthApiEnvelope> resetPassword(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiEndpoints.refreshToken)
  Future<AuthApiEnvelope> refreshToken(
    @Body() Map<String, dynamic> body,
  );
}
