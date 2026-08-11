/// Exceptions thrown by the **data layer** (data sources) only.
///
/// Repositories catch these and translate them into [Failure]s before
/// anything crosses into the domain/presentation layers — see
/// `core/error/failures.dart` for the corresponding sealed hierarchy and
/// `core/result/result.dart` for how repositories surface them.
class ServerException implements Exception {
  const ServerException([this.message = 'Server error.']);

  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache error.']);
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection.']);
}
