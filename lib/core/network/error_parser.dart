import 'package:dio/dio.dart';

import '../error/exceptions.dart';
import '../error/failures.dart';

/// Central place any thrown error (DioException or this project's typed exceptions) becomes a typed [Failure], so no repository re-implements its own catch switch.
abstract final class ErrorParser {
  const ErrorParser._();

  static Failure parse(Object error, [StackTrace? stackTrace]) {
    return switch (error) {
      DioException dioError => _fromDioException(dioError),
      InvalidCredentialsException() => const InvalidCredentialsFailure(),
      InvalidVerificationCodeException() =>
        const InvalidVerificationCodeFailure(),
      InvalidSessionException() => const AuthFailure(),
      EmailNotFoundException() => const NotFoundFailure(),
      NetworkException() => const NetworkFailure(),
      ApiException apiError => _fromApiException(apiError),
      ServerException() => const ServerFailure(),
      CacheException() => const ServerFailure(),
      // Pass through a Failure produced upstream (e.g. a composed repository call) instead of double-wrapping it.
      Failure failure => failure,
      _ => const UnexpectedFailure(),
    };
  }

  static Failure _fromApiException(ApiException error) {
    return _fromStatusCode(error.statusCode, error.message);
  }

  /// Timeout/status-code handling for whatever a Retrofit call throws.
  static Failure _fromDioException(DioException error) {
    switch (error.type) {
      // Genuine time-budget failures (request sent/received too slowly) — distinct from having no connectivity at all.
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutFailure();
      // No connection could be established in the first place.
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final message = _extractServerMessage(error.response?.data) ??
            'Server error (HTTP $statusCode).';
        return _fromStatusCode(statusCode, message);
      case DioExceptionType.cancel:
        return const ServerFailure('Request was cancelled.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const UnexpectedFailure();
    }
  }

  /// Single HTTP-status-code → [Failure] mapping shared by both the Retrofit/Dio path and the legacy [ApiException] path, so the two can never drift apart.
  static Failure _fromStatusCode(int statusCode, String message) {
    return switch (statusCode) {
      400 || 422 => ValidationFailure(message),
      401 => UnauthorizedFailure(message),
      403 => ForbiddenFailure(message),
      404 => NotFoundFailure(message),
      409 => ConflictFailure(message),
      429 => RateLimitedFailure(message),
      // Covers both 5xx and any other unmapped status with a plain ServerFailure.
      _ => ServerFailure(message),
    };
  }

  /// Prefers `errors[0]` over `message` — confirmed live that this backend's envelope often leaves `message` blank on failure.
  static String? _extractServerMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        final firstError = errors.first;
        if (firstError is String && firstError.isNotEmpty) return firstError;
      }
      final candidate = data['message'] ?? data['error'] ?? data['title'];
      if (candidate is String && candidate.isNotEmpty) return candidate;
    }
    return null;
  }
}
