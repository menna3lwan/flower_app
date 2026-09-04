// coverage:ignore-file
// ignore_for_file: type=lint

part of 'auth_api_service.dart';

// Hand-written stand-in for RetrofitGenerator's output (no Dart/Flutter SDK in this sandbox) — same externally observable behavior as real generated code; run build_runner elsewhere to replace it.

class _AuthApiService implements AuthApiService {
  _AuthApiService(this._dio, {this.baseUrl});

  final Dio _dio;

  // Not part of AuthApiService's abstract interface — just this implementation's storage for the optional base-URL override.
  final String? baseUrl;

  @override
  Future<Map<String, dynamic>> login(Map<String, dynamic> body) =>
      _post(ApiEndpoints.userLogin, body);

  @override
  Future<Map<String, dynamic>> signUp(Map<String, dynamic> body) =>
      _post(ApiEndpoints.register, body);

  @override
  Future<Map<String, dynamic>> forgotPassword(Map<String, dynamic> body) =>
      _post(ApiEndpoints.forgotPassword, body);

  @override
  Future<Map<String, dynamic>> verifyOtp(Map<String, dynamic> body) =>
      _post(ApiEndpoints.verifyOtp, body);

  @override
  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> body) =>
      _post(ApiEndpoints.resetPassword, body);

  @override
  Future<Map<String, dynamic>> refreshToken(Map<String, dynamic> body) =>
      _post(ApiEndpoints.refreshToken, body);

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final effectivePath = baseUrl == null ? path : '$baseUrl$path';
    final response = await _dio.post<Map<String, dynamic>>(
      effectivePath,
      data: body,
    );
    return response.data ?? const <String, dynamic>{};
  }
}
