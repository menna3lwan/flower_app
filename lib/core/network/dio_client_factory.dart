import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../localization/current_language.dart';
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
  dio.interceptors.add(AcceptLanguageInterceptor());

  // Verbose logging only in debug builds — never release, where it would leak tokens/PII.
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  return dio;
}

/// Sends the app's language on every request so backend error/success messages arrive already localized.
class AcceptLanguageInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.headers['Accept-Language'] = CurrentLanguage.code;
    handler.next(options);
  }
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
