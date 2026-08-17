import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/secure_storage_service.dart';
import 'api_endpoints.dart';
Dio createDioClient(SecureStorageService secureStorage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: ApiEndpoints.connectTimeout,
      receiveTimeout: ApiEndpoints.receiveTimeout,
      contentType: Headers.jsonContentType,
    ),
  );

  dio.interceptors.add(AuthorizationInterceptor(secureStorage));

  // Verbose request/response logging only in debug builds — never in a
  // release build, where it would leak tokens/PII into device logs.
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  return dio;
}

class AuthorizationInterceptor extends Interceptor {
  AuthorizationInterceptor(this._secureStorage);

  final SecureStorageService _secureStorage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
