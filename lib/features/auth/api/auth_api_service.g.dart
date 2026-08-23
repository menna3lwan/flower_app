// coverage:ignore-file
// ignore_for_file: type=lint

part of 'auth_api_service.dart';

// **************************************************************************
// HAND-WRITTEN STAND-IN FOR RetrofitGenerator'S OUTPUT
//
// This environment could not run `dart run build_runner build` while this
// refactor was authored (no Dart/Flutter SDK reachable from the sandbox
// that wrote it), so this part file is a manually written implementation
// of the exact same `AuthApiService` interface declared in
// `auth_api_service.dart` — same method signatures, same externally
// observable behavior: each method POSTs `body` as JSON to its
// `ApiEndpoints` path over the injected [Dio] instance (so every
// interceptor registered in `core/network/dio_client_factory.dart` —
// auth header, Accept-Language, logging — still runs), returns the
// decoded JSON body as `Map<String, dynamic>`, and lets any non-2xx
// response surface as Dio's own `DioException` exactly like real
// Retrofit-generated code does, which `ErrorParser` already knows how to
// read (see `core/network/error_parser.dart`).
//
// It deliberately does NOT try to hand-replicate retrofit_generator's
// internal `RequestOptions`-composition machinery (`_setStreamType`,
// `compose`, base-URL combination, etc.) — that has no externally
// observable difference from a plain `dio.post(...)` call for this
// project's usage (no multipart/query-parameter/header-annotation
// methods on this service), and hand-guessing generator internals with
// no compiler to check them against is a real correctness risk, whereas
// this is ordinary, verifiable Dio usage.
//
// Run `dart run build_runner build --delete-conflicting-outputs` to
// replace this file with the real generated one. Nothing outside this
// file needs to change when that happens — every caller only ever
// depends on the abstract `AuthApiService`, never on `_AuthApiService`.
// **************************************************************************

class _AuthApiService implements AuthApiService {
  _AuthApiService(this._dio, {this.baseUrl});

  final Dio _dio;

  // Not part of AuthApiService's own abstract interface (only the
  // factory constructor declares it) — just this implementation's own
  // storage for the optional base-URL override, hence no @override here.
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
