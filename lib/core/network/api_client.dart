import '../error/exceptions.dart';

/// Transport-agnostic HTTP contract; no `dio`/`http` package yet since nothing calls a real endpoint (YAGNI).
abstract interface class ApiClient {
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters});

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body});

  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body});

  Future<void> delete(String path);
}

/// Throws until a real client is registered, so no feature can silently think it's talking to a server.
class UnimplementedApiClient implements ApiClient {
  const UnimplementedApiClient();

  Never _unimplemented() => throw const ServerException(
        'No ApiClient implementation is registered yet. Every current '
        'feature reads from an in-memory placeholder data source instead.',
      );

  @override
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters}) => _unimplemented();

  @override
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) => _unimplemented();

  @override
  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body}) => _unimplemented();

  @override
  Future<void> delete(String path) => _unimplemented();
}
