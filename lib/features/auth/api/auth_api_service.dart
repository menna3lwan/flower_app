import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/network/api_endpoints.dart';

part 'auth_api_service.g.dart';

/// The Auth module's complete API surface — method signatures only.
///
/// This class must never contain parsing or business logic: reading the
/// response envelope, persisting tokens, mapping errors, and so on all
/// live in `AuthRemoteDataSourceImpl`, `AuthApiEnvelope`, and
/// `ErrorParser` respectively. Retrofit generates the actual Dio call
/// body for each method into `auth_api_service.g.dart` at build time —
/// see that file's header comment for why a hand-written stand-in is
/// checked in here instead of real generator output.
///
/// Every path comes from [ApiEndpoints] (the same constants
/// `AuthRemoteDataSourceImpl` used to call through the old [ApiClient]),
/// so the Gateway route list has exactly one source of truth regardless
/// of which HTTP layer calls it.
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
