// coverage:ignore-file
// ignore_for_file: type=lint

part of 'home_api_service.dart';

// Hand-written stand-in for RetrofitGenerator's output — same externally observable behavior as real generated code; run build_runner to replace it for real.

class _HomeApiService implements HomeApiService {
  _HomeApiService(this._dio, {this.baseUrl});

  final Dio _dio;

  // Not part of HomeApiService's abstract interface — just this implementation's storage for the optional base-URL override.
  final String? baseUrl;

  @override
  Future<Map<String, dynamic>> getHomeSections() async {
    final effectivePath =
        baseUrl == null ? ApiEndpoints.homeSections : '$baseUrl${ApiEndpoints.homeSections}';
    final response = await _dio.get<Map<String, dynamic>>(effectivePath);
    return response.data ?? const <String, dynamic>{};
  }
}
