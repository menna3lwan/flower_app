import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:customer_app/core/domain/entities/user_entity.dart';
import 'package:customer_app/core/error/exceptions.dart';
import 'package:customer_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';

import '../../../../support/fake_secure_storage_service.dart';
import '../../../../support/mocks.dart';

/// Builds a syntactically valid unsigned JWT carrying [claims] — enough for [JwtPayloadDecoder], which never inspects the header/signature.
String _fakeJwt(Map<String, dynamic> claims) {
  String segment(Object value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  return '${segment({
        'alg': 'none'
      })}.${segment(claims)}.signature';
}

void main() {
  late MockAuthApiService apiService;
  late FakeSecureStorageService secureStorage;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    apiService = MockAuthApiService();
    secureStorage = FakeSecureStorageService();
    dataSource = AuthRemoteDataSourceImpl(apiService, secureStorage);
  });

  group('login', () {
    test('persists the session and builds a user from the JWT claims',
        () async {
      final accessToken = _fakeJwt({
        'unique_name': 'Nour Mohamed',
        'nameid': 'user-1',
        'email': 'test@flowery.com',
      });
      // Stubbed against the exact JSON body sent, not any/captureAny — Mockito types those as Null, rejected by the analyzer for a required non-nullable body param.
      when(apiService.login({'email': 'test@flowery.com', 'password': 'Password123'}))
          .thenAnswer((_) async => {
            'status': true,
            'data': {
              'accessToken': accessToken,
              'refreshToken': 'refresh-1',
              'expiresIn': 3600,
            },
            'errors': null,
            'code': 200,
            'message': null,
          });

      final user = await dataSource.login(
        email: 'test@flowery.com',
        password: 'Password123',
      );

      expect(user.id, 'user-1');
      expect(user.firstName, 'Nour');
      expect(user.lastName, 'Mohamed');
      expect(user.email, 'test@flowery.com');
      expect(await secureStorage.readToken(), accessToken);
      expect(await secureStorage.readRefreshToken(), 'refresh-1');
      expect(await secureStorage.readTokenExpiry(), isNotNull);
    });

    test('propagates whatever the API service throws', () async {
      when(apiService.login({'email': 'a@b.com', 'password': 'wrong'}))
          .thenThrow(const InvalidCredentialsException());

      expect(
        () => dataSource.login(email: 'a@b.com', password: 'wrong'),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });
  });

  group('signUp', () {
    test('returns a user built from the submitted fields, not invented',
        () async {
      when(apiService.signUp({
        'fullName': 'Sara Ali',
        'email': 'sara@flowery.com',
        'phoneNumber': '01012345678',
        'gender': 2,
        'password': 'Password123',
        'confirmPassword': 'Password123',
      })).thenAnswer((_) async => {
            'status': true,
            'data': 'new-user-id',
            'errors': null,
            'code': 201,
            'message': null,
          });

      final user = await dataSource.signUp(
        firstName: 'Sara',
        lastName: 'Ali',
        email: 'sara@flowery.com',
        password: 'Password123',
        confirmPassword: 'Password123',
        phoneNumber: '01012345678',
        gender: Gender.female,
      );

      expect(user.id, 'new-user-id');
      expect(user.firstName, 'Sara');
      expect(user.lastName, 'Ali');
      expect(user.gender, Gender.female);
      // Sign Up never starts a session.
      expect(await secureStorage.readToken(), isNull);
    });

    test('sends the confirmed Gender wire mapping (male=1, female=2)',
        () async {
      when(apiService.signUp({
        'fullName': 'A B',
        'email': 'a@b.com',
        'phoneNumber': '01000000000',
        'gender': 1,
        'password': 'Password123',
        'confirmPassword': 'Password123',
      })).thenAnswer((_) async => {
            'status': true,
            'data': 'id',
          });

      await dataSource.signUp(
        firstName: 'A',
        lastName: 'B',
        email: 'a@b.com',
        password: 'Password123',
        confirmPassword: 'Password123',
        phoneNumber: '01000000000',
        gender: Gender.male,
      );

      final body =
          verify(apiService.signUp(captureAny as dynamic)).captured.single
              as Map;
      expect(body['gender'], 1);
    });
  });

  group('verifyCode', () {
    test('returns the resetToken from the response envelope', () async {
      when(apiService.verifyOtp({'email': 'a@b.com', 'otp': '1234'}))
          .thenAnswer((_) async => {
                'status': true,
                'data': {'resetToken': 'reset-token-123'},
              });

      final resetToken = await dataSource.verifyCode(
        email: 'a@b.com',
        code: '1234',
      );

      expect(resetToken, 'reset-token-123');
    });

    test('propagates a wrong-code exception unchanged', () async {
      when(apiService.verifyOtp({'email': 'a@b.com', 'otp': '0000'}))
          .thenThrow(const InvalidVerificationCodeException());

      expect(
        () => dataSource.verifyCode(email: 'a@b.com', code: '0000'),
        throwsA(isA<InvalidVerificationCodeException>()),
      );
    });
  });

  group('resetPassword', () {
    test('posts the resetToken/newPassword/confirmNewPassword as-is',
        () async {
      // A bare {} isn't a real success envelope — confirmed live that an empty/absent `status` actually defaults to a *failure* envelope.
      when(apiService.resetPassword({
        'resetToken': 'token-1',
        'newPassword': 'NewPassword123',
        'confirmNewPassword': 'NewPassword123',
      })).thenAnswer((_) async => {'status': true});

      await dataSource.resetPassword(
        resetToken: 'token-1',
        newPassword: 'NewPassword123',
        confirmNewPassword: 'NewPassword123',
      );

      final body =
          verify(apiService.resetPassword(captureAny as dynamic)).captured
              .single as Map;
      expect(body['resetToken'], 'token-1');
      expect(body['newPassword'], 'NewPassword123');
    });
  });

  group('refreshSession', () {
    test('throws InvalidSessionException when there is no refresh token',
        () async {
      expect(
        () => dataSource.refreshSession(),
        throwsA(isA<InvalidSessionException>()),
      );
      verifyNever(apiService.refreshToken(any as dynamic));
    });

    test('calls the API and persists the new session when one exists',
        () async {
      await secureStorage.saveRefreshToken('old-refresh');
      when(apiService.refreshToken({'refreshToken': 'old-refresh'}))
          .thenAnswer((_) async => {
            'status': true,
            'data': {
              'accessToken': 'new-access',
              'refreshToken': 'new-refresh',
              'expiresIn': 1800,
            },
          });

      await dataSource.refreshSession();

      expect(await secureStorage.readToken(), 'new-access');
      expect(await secureStorage.readRefreshToken(), 'new-refresh');
    });
  });
}
