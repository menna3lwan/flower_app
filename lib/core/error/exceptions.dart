/// Exceptions thrown by the data layer only; repositories catch these and translate them into [Failure]s.
class ServerException implements Exception {
  const ServerException([this.message = 'Server error.']);

  final String message;
}

class CacheException implements Exception {
  final dynamic message;

  const CacheException([this.message = 'Cache error.']);
}

class NetworkException implements Exception {
  final dynamic message;

  const NetworkException([this.message = 'No internet connection.']);
}
