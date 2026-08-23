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

  // Verbose request/response logging only in debug builds — never in a
  // release build, where it would leak tokens/PII into device logs.
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  return dio;
}

/// Sends the app's current language on every request — every Auth
/// endpoint declares this header (`docker/auth-swagger.json`) and uses
/// it to localize error/success messages, so the backend's own text
/// arrives already in the user's language instead of only the app's
/// client-side copy being localized.
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
