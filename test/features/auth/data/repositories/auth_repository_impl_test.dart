import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:customer_app/core/domain/entities/user_entity.dart';
import 'package:customer_app/core/error/exceptions.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/features/auth/data/repositories/auth_repository_impl.dart';

import '../../../../support/mocks.dart';

const _user = UserEntity(
  id: 'user-1',
  firstName: 'Nour',
  lastName: 'Mohamed',
  email: 'test@flowery.com',
);

void main() {
  late MockAuthLocalDataSource dataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    dataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(dataSource);
  });

  group('login', () {
    test('wraps a successful data-source call as Result.success', () async {
      when(dataSource.login(email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => _user);

      final result =
          await repository.login(email: 'a@b.com', password: 'Password123');

      expect(result.isSuccess, isTrue);
      result.fold(
        (failure) => fail('expected success, got $failure'),
        (user) => expect(user, _user),
      );
    });

    test('turns a thrown exception into the matching Failure via safeCall',
        () async {
      when(dataSource.login(email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(const InvalidCredentialsException());

      final result =
          await repository.login(email: 'a@b.com', password: 'wrong');

      expect(result.isFailure, isTrue);
      result.fold(
        (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
        (user) => fail('expected failure, got $user'),
      );
    });
  });

  group('signUp', () {
    test('propagates a Conflict (existing email) as ConflictFailure',
        () async {
      when(dataSource.signUp(
        firstName: anyNamed('firstName'),
        lastName: anyNamed('lastName'),
        email: anyNamed('email'),
        password: anyNamed('password'),
        confirmPassword: anyNamed('confirmPassword'),
        phoneNumber: anyNamed('phoneNumber'),
        gender: anyNamed('gender'),
      )).thenThrow(
        const ApiException(statusCode: 409, message: 'Email already exists.'),
      );

      final result = await repository.signUp(
        firstName: 'A',
        lastName: 'B',
        email: 'a@b.com',
        password: 'Password123',
        confirmPassword: 'Password123',
        phoneNumber: '01000000000',
        gender: Gender.female,
      );

      expect(result.isFailure, isTrue);
      result.fold(
        (failure) => expect(failure, isA<ConflictFailure>()),
        (user) => fail('expected failure, got $user'),
      );
    });
  });

  group('verifyCode', () {
    test('success returns the resetToken', () async {
      when(dataSource.verifyCode(
        email: anyNamed('email'),
        code: anyNamed('code'),
      )).thenAnswer((_) async => 'reset-token');

      final result =
          await repository.verifyCode(email: 'a@b.com', code: '1234');

      result.fold(
        (failure) => fail('expected success, got $failure'),
        (token) => expect(token, 'reset-token'),
      );
    });

    test('a wrong code becomes InvalidVerificationCodeFailure', () async {
      when(dataSource.verifyCode(
        email: anyNamed('email'),
        code: anyNamed('code'),
      )).thenThrow(const InvalidVerificationCodeException());

      final result =
          await repository.verifyCode(email: 'a@b.com', code: '0000');

      result.fold(
        (failure) => expect(failure, isA<InvalidVerificationCodeFailure>()),
        (token) => fail('expected failure, got $token'),
      );
    });
  });

  group('resetPassword', () {
    test('an expired/invalid token surfaces as NotFoundFailure', () async {
      when(dataSource.resetPassword(
        resetToken: anyNamed('resetToken'),
        newPassword: anyNamed('newPassword'),
        confirmNewPassword: anyNamed('confirmNewPassword'),
      )).thenThrow(
        const ApiException(statusCode: 404, message: 'Token not found.'),
      );

      final result = await repository.resetPassword(
        resetToken: 'expired',
        newPassword: 'NewPassword123',
        confirmNewPassword: 'NewPassword123',
      );

      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('expected failure'),
      );
    });

    test('success returns Result<void> with no failure', () async {
      when(dataSource.resetPassword(
        resetToken: anyNamed('resetToken'),
        newPassword: anyNamed('newPassword'),
        confirmNewPassword: anyNamed('confirmNewPassword'),
      )).thenAnswer((_) async {});

      final result = await repository.resetPassword(
        resetToken: 'valid',
        newPassword: 'NewPassword123',
        confirmNewPassword: 'NewPassword123',
      );

      expect(result.isSuccess, isTrue);
    });
  });

  group('sendPasswordResetEmail', () {
    test('an unknown email surfaces as NotFoundFailure', () async {
      when(dataSource.sendPasswordResetEmail(any))
          .thenThrow(const EmailNotFoundException());

      final result = await repository.sendPasswordResetEmail('nobody@x.com');

      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('expected failure'),
      );
    });
  });
}
