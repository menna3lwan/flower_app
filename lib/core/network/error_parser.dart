import 'package:dio/dio.dart';

import '../error/exceptions.dart';
import '../error/failures.dart';

/// The single place any thrown error — Retrofit/Dio, the legacy
/// [ApiClient]/[DioApiClient] exception types, or anything unexpected —
/// becomes a typed [Failure].
///
/// Two error shapes reach this parser today:
///
/// * A raw [DioException] — what Retrofit-generated API services throw
///   directly (see `features/auth/api/auth_api_service.dart`), since
///   Retrofit calls straight into Dio without going through
///   [DioApiClient]'s own try/catch.
/// * The project's existing typed exceptions ([ApiException],
///   [NetworkException], [ServerException], [CacheException], and the
///   Auth-specific ones) — what [DioApiClient] (still used by any
///   feature not yet on Retrofit) and [AuthLocalDataSourceImpl]'s fake
///   throw.
///
/// Centralizing both here — instead of each repository re-implementing
/// its own `catch (e)` switch, as `AuthRepositoryImpl._mapException` used
/// to — is what [safeCall] (`core/base/safe_call.dart`) relies on to stay
/// a two-line function.
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
      // Something upstream already produced a Failure (e.g. a repository
      // composing another repository's Result) — pass it through instead
      // of double-wrapping it into UnexpectedFailure.
      Failure failure => failure,
      _ => const UnexpectedFailure(),
    };
  }

  static Failure _fromApiException(ApiException error) {
    final statusCode = error.statusCode;
    final message = error.message;
    return switch (statusCode) {
      400 || 422 => ValidationFailure(message),
      401 || 403 => AuthFailure(message),
      404 => NotFoundFailure(message),
      409 => ConflictFailure(message),
      429 => RateLimitedFailure(message),
      _ when statusCode >= 500 => ServerFailure(message),
      _ => ServerFailure(message),
    };
  }

  /// Mirrors [DioApiClient]'s own timeout/status-code handling so a
  /// Retrofit call and a plain [ApiClient] call that hit the exact same
  /// backend condition end up as the exact same [Failure] type.
  static Failure _fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.transformTimeout:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final message = _extractServerMessage(error.response?.data) ??
            'Server error (HTTP $statusCode).';
        return switch (statusCode) {
          400 || 422 => ValidationFailure(message),
          401 || 403 => AuthFailure(message),
          404 => NotFoundFailure(message),
          409 => ConflictFailure(message),
          429 => RateLimitedFailure(message),
          _ when statusCode >= 500 => ServerFailure(message),
          _ => ServerFailure(message),
        };
      case DioExceptionType.cancel:
        return const ServerFailure('Request was cancelled.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const UnexpectedFailure();
    }
  }

  /// Reads this backend's response envelope (`{status, data, errors,
  /// code, message}` — see `AuthApiEnvelope`): the human-readable reason
  /// lives in `errors[0]` far more often than in `message` (confirmed
  /// against the live Auth service — a 401 routinely arrives as
  /// `{"message":""}` with the real text in `errors`), so `errors` is
  /// checked first. Falls back to `message`/`error`/`title` for any
  /// other endpoint that doesn't follow this exact envelope shape.
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
