import '../error/exceptions.dart';

/// Transport-agnostic HTTP contract the data layer will depend on once a
/// real backend exists.
///
/// Deliberately has zero third-party dependency (no `dio`/`http` import)
/// at this stage — adding an HTTP package before there is a single real
/// endpoint to call would be an unused dependency, which violates YAGNI.
/// When the backend lands, implement [ApiClient] with the team's chosen
/// package and register it in `core/di/injector.dart`; no data source
/// call site changes because they will depend on this interface, not the
/// concrete client.
abstract interface class ApiClient {
  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters});

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body});

  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body});

  Future<void> delete(String path);
}

/// Throws until a real client is registered — makes it impossible to
/// silently ship a feature that thinks it's talking to a server.
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
