import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import '../error/exceptions.dart';


abstract interface class ApiClient {
  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters});

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body});

  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body});

  Future<void> delete(String path);
}


class UnimplementedApiClient implements ApiClient {
  const UnimplementedApiClient();

  Never _unimplemented() => throw const ServerException(
        'No ApiClient implementation is registered yet. Every current '
        'feature reads from an in-memory placeholder data source instead.',
      );

  @override
  Future<Map<String, dynamic>> get(String path,
          {Map<String, dynamic>? queryParameters}) =>
      _unimplemented();

  @override
  Future<Map<String, dynamic>> post(String path,
          {Map<String, dynamic>? body}) =>
      _unimplemented();

  @override
  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body}) =>
      _unimplemented();

  @override
  Future<void> delete(String path) => _unimplemented();
}


class DioApiClient implements ApiClient {
  DioApiClient(this._dio);

  final Dio _dio;

  @override
  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) {
    return _handle(() => _dio.get(path, queryParameters: queryParameters));
  }

  @override
  Future<Map<String, dynamic>> post(String path,
      {Map<String, dynamic>? body}) {
    return _handle(() => _dio.post(path, data: body));
  }

  @override
  Future<Map<String, dynamic>> put(String path,
      {Map<String, dynamic>? body}) {
    return _handle(() => _dio.put(path, data: body));
  }

  @override
  Future<void> delete(String path) {
    return _handle(() => _dio.delete(path));
  }

  Future<Map<String, dynamic>> _handle(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      return _asMap(response.data);
    } on DioException catch (error) {
      _rethrowMapped(error);
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data == null) return const <String, dynamic>{};
    if (data is Map<String, dynamic>) return data;

    return <String, dynamic>{'data': data};
  }

  Never _rethrowMapped(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      // Timed out converting the request/response body — same practical
      // meaning as the other timeouts from the caller's point of view.
      case DioExceptionType.transformTimeout:
        throw const NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        throw ApiException(
          statusCode: statusCode,
          message: _extractServerMessage(error.response?.data) ??
              'Server error (HTTP $statusCode).',
        );
      case DioExceptionType.cancel:
        throw const ServerException('Request was cancelled.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        throw const ServerException();
    }
  }


  String? _extractServerMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      // This backend's response envelope (see auth_api_envelope.dart)
      // puts the actual human-readable reason in `errors[0]` and
      // frequently leaves `message` blank (e.g. `{"message":""}` on a
      // 401) — confirmed against the live Auth service. Prefer it.
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        final firstError = errors.first;
        if (firstError is String && firstError.isNotEmpty) return firstError;
      }
      final candidate = data['message'] ?? data['error'] ?? data['title'];
      if (candidate is String && candidate.isNotEmpty) return candidate;
    }
    return null;
  }
}
