/// Placeholder for the future remote API's base URL and route paths.
///
/// No feature calls a real endpoint yet — every data source in this
/// codebase is an in-memory placeholder (see each feature's
/// `data/datasources` folder). This file exists so that the moment a
/// backend is available, endpoints are added in exactly one place rather
/// than hunting string literals through every data source.
abstract final class ApiEndpoints {
  const ApiEndpoints._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.flowerapp.example.com',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Route paths are added here per-resource as the backend comes online,
  // e.g. `static const String login = '/auth/login';`.
}
