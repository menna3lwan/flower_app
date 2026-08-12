/// Placeholder for the future remote API's base URL and route paths — none in use yet.
abstract final class ApiEndpoints {
  const ApiEndpoints._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.flowerapp.example.com',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Route paths are added here per-resource as the backend comes online.
}
