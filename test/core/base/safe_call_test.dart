import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/core/base/safe_call.dart';
import 'package:customer_app/core/error/exceptions.dart';
import 'package:customer_app/core/error/failures.dart';

void main() {
  group('safeCall', () {
    test('wraps a successful operation as Result.success', () async {
      final result = await safeCall(() async => 42);

      expect(result.isSuccess, isTrue);
      result.fold(
        (failure) => fail('expected success, got $failure'),
        (data) => expect(data, 42),
      );
    });

    test('turns a thrown exception into Result.failure via ErrorParser',
        () async {
      final result = await safeCall<int>(
        () async => throw const InvalidCredentialsException(),
      );

      expect(result.isFailure, isTrue);
      result.fold(
        (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
        (data) => fail('expected failure, got $data'),
      );
    });

    test('never lets the exception escape safeCall itself', () async {
      // If ErrorParser ever regresses to rethrowing instead of mapping,
      // this call would throw and fail the test on its own — no
      // try/catch needed around it here.
      final result = await safeCall<int>(() async => throw StateError('x'));
      expect(result.isFailure, isTrue);
    });
  });
}
