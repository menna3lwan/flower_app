import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/core/error/exceptions.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/network/error_parser.dart';

RequestOptions _requestOptions() => RequestOptions(path: '/test');

DioException _dioError({
  required DioExceptionType type,
  int? statusCode,
  dynamic responseData,
}) {
  final options = _requestOptions();
  return DioException(
    requestOptions: options,
    type: type,
    response: statusCode == null
        ? null
        : Response(
            requestOptions: options,
            statusCode: statusCode,
            data: responseData,
          ),
  );
}

void main() {
  group('ErrorParser.parse — DioException', () {
    test('every timeout/connection variant becomes NetworkFailure', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
        DioExceptionType.transformTimeout,
      ]) {
        final failure = ErrorParser.parse(_dioError(type: type));
        expect(failure, isA<NetworkFailure>(), reason: type.toString());
      }
    });

    test('400 becomes ValidationFailure using the envelope\'s errors[0]',
        () {
      final failure = ErrorParser.parse(_dioError(
        type: DioExceptionType.badResponse,
        statusCode: 400,
        responseData: {
          'status': false,
          'errors': ['Email is required.'],
          'message': '',
        },
      ));
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, 'Email is required.');
    });

    test('422 also becomes ValidationFailure', () {
      final failure = ErrorParser.parse(_dioError(
        type: DioExceptionType.badResponse,
        statusCode: 422,
        responseData: {'errors': <String>[]},
      ));
      expect(failure, isA<ValidationFailure>());
    });

    test('401 becomes AuthFailure', () {
      final failure = ErrorParser.parse(_dioError(
        type: DioExceptionType.badResponse,
        statusCode: 401,
        responseData: {'message': 'Unauthorized'},
      ));
      expect(failure, isA<AuthFailure>());
    });

    test('403 also becomes AuthFailure', () {
      final failure = ErrorParser.parse(_dioError(
        type: DioExceptionType.badResponse,
        statusCode: 403,
      ));
      expect(failure, isA<AuthFailure>());
    });

    test('404 becomes NotFoundFailure', () {
      final failure = ErrorParser.parse(_dioError(
        type: DioExceptionType.badResponse,
        statusCode: 404,
      ));
      expect(failure, isA<NotFoundFailure>());
    });

    test('409 becomes ConflictFailure', () {
      final failure = ErrorParser.parse(_dioError(
        type: DioExceptionType.badResponse,
        statusCode: 409,
      ));
      expect(failure, isA<ConflictFailure>());
    });

    test('429 becomes RateLimitedFailure', () {
      final failure = ErrorParser.parse(_dioError(
        type: DioExceptionType.badResponse,
        statusCode: 429,
      ));
      expect(failure, isA<RateLimitedFailure>());
    });

    test('every 5xx becomes ServerFailure', () {
      for (final statusCode in [500, 502, 503]) {
        final failure = ErrorParser.parse(_dioError(
          type: DioExceptionType.badResponse,
          statusCode: statusCode,
        ));
        expect(failure, isA<ServerFailure>(), reason: '$statusCode');
      }
    });

    test('cancel becomes ServerFailure', () {
      final failure =
          ErrorParser.parse(_dioError(type: DioExceptionType.cancel));
      expect(failure, isA<ServerFailure>());
    });

    test('badCertificate/unknown become UnexpectedFailure', () {
      for (final type in [
        DioExceptionType.badCertificate,
        DioExceptionType.unknown,
      ]) {
        final failure = ErrorParser.parse(_dioError(type: type));
        expect(failure, isA<UnexpectedFailure>(), reason: type.toString());
      }
    });
  });

  group('ErrorParser.parse — legacy typed exceptions', () {
    test('ApiException maps by status code the same way as DioException',
        () {
      expect(
        ErrorParser.parse(
            const ApiException(statusCode: 401, message: 'nope')),
        isA<AuthFailure>(),
      );
      expect(
        ErrorParser.parse(
            const ApiException(statusCode: 409, message: 'exists')),
        isA<ConflictFailure>(),
      );
      expect(
        ErrorParser.parse(
            const ApiException(statusCode: 429, message: 'slow down')),
        isA<RateLimitedFailure>(),
      );
    });

    test('NetworkException -> NetworkFailure', () {
      expect(
        ErrorParser.parse(const NetworkException()),
        isA<NetworkFailure>(),
      );
    });

    test('ServerException / CacheException -> ServerFailure', () {
      expect(ErrorParser.parse(const ServerException()), isA<ServerFailure>());
      expect(ErrorParser.parse(const CacheException()), isA<ServerFailure>());
    });

    test('InvalidCredentialsException -> InvalidCredentialsFailure', () {
      expect(
        ErrorParser.parse(const InvalidCredentialsException()),
        isA<InvalidCredentialsFailure>(),
      );
    });

    test(
        'InvalidVerificationCodeException -> InvalidVerificationCodeFailure',
        () {
      expect(
        ErrorParser.parse(const InvalidVerificationCodeException()),
        isA<InvalidVerificationCodeFailure>(),
      );
    });

    test('EmailNotFoundException -> NotFoundFailure', () {
      expect(
        ErrorParser.parse(const EmailNotFoundException()),
        isA<NotFoundFailure>(),
      );
    });

    test('InvalidSessionException -> AuthFailure', () {
      expect(
        ErrorParser.parse(const InvalidSessionException()),
        isA<AuthFailure>(),
      );
    });

    test('a totally unrecognized error -> UnexpectedFailure', () {
      expect(ErrorParser.parse(StateError('boom')), isA<UnexpectedFailure>());
    });
  });
}
