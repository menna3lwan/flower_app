import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/core/domain/entities/user_entity.dart';
import 'package:customer_app/core/error/exceptions.dart';
import 'package:customer_app/features/auth/api/auth_api_service.dart';
import 'package:customer_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:customer_app/features/auth/data/models/auth_api_envelope.dart';

import '../../../../support/fake_secure_storage_service.dart';

/// Builds a syntactically valid unsigned JWT carrying [claims] — enough for [JwtPayloadDecoder], which never inspects the header/signature.
String _fakeJwt(Map<String, dynamic> claims) {
  String segment(Object value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  return '${segment({
        'alg': 'none'
      })}.${segment(claims)}.signature';
}

AuthApiEnvelope _envelope({
  bool status = true,
  dynamic data,
  List<String>? errors,
  int? code,
  String? message,
}) {
  return AuthApiEnvelope(
    status: status,
    data: data,
    errors: errors,
    code: code,
    message: message,
  );
}

/// Records request bodies and returns configured envelopes. A hand-written
/// Mockito `Mock` cannot stub `Future<AuthApiEnvelope>` without codegen/dummies.
class _StubAuthApiService implements AuthApiService {
  final Map<String, AuthApiEnvelope> _responses = {};
  final Map<String, Object> _errors = {};
  final Map<String, Map<String, dynamic>> lastBodies = {};
  final Map<String, int> callCounts = {};

  void succeed(String method, AuthApiEnvelope envelope) =>
      _responses[method] = envelope;

  void fail(String method, Object error) => _errors[method] = error;

  Future<AuthApiEnvelope> _handle(
    String method,
    Map<String, dynamic> body,
  ) async {
    lastBodies[method] = Map<String, dynamic>.from(body);
    callCounts[method] = (callCounts[method] ?? 0) + 1;
    final error = _errors[method];
    if (error != null) throw error;
    final response = _responses[method];
    if (response == null) {
      throw StateError('No stub configured for $method');
    }
    return response;
  }

  @override
  Future<AuthApiEnvelope> login(Map<String, dynamic> body) =>
      _handle('login', body);

  @override
  Future<AuthApiEnvelope> signUp(Map<String, dynamic> body) =>
      _handle('signUp', body);

  @override
  Future<AuthApiEnvelope> forgotPassword(Map<String, dynamic> body) =>
      _handle('forgotPassword', body);

  @override
  Future<AuthApiEnvelope> verifyOtp(Map<String, dynamic> body) =>
      _handle('verifyOtp', body);

  @override
  Future<AuthApiEnvelope> resetPassword(Map<String, dynamic> body) =>
      _handle('resetPassword', body);

  @override
  Future<AuthApiEnvelope> refreshToken(Map<String, dynamic> body) =>
      _handle('refreshToken', body);
}

void main() {
  late _StubAuthApiService apiService;
  late FakeSecureStorageService secureStorage;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    apiService = _StubAuthApiService();
    secureStorage = FakeSecureStorageService();
    dataSource = AuthRemoteDataSourceImpl(apiService, secureStorage);
  });

  group('login', () {
    const email = 'test@flowery.com';
    const password = 'Password123';
    const loginBody = {'email': email, 'password': password};

    test('persists the session and builds a user from the JWT claims',
        () async {
      final accessToken = _fakeJwt({
        'unique_name': 'Nour Mohamed',
        'nameid': 'user-1',
        'email': email,
      });
      apiService.succeed(
        'login',
        _envelope(
          data: {
            'accessToken': accessToken,
            'refreshToken': 'refresh-1',
            'expiresIn': 3600,
          },
          code: 200,
        ),
      );

      final user = await dataSource.login(email: email, password: password);

      expect(apiService.lastBodies['login'], loginBody);
      expect(user.id, 'user-1');
      expect(user.firstName, 'Nour');
      expect(user.lastName, 'Mohamed');
      expect(user.email, email);
      expect(await secureStorage.readToken(), accessToken);
      expect(await secureStorage.readRefreshToken(), 'refresh-1');
      expect(await secureStorage.readTokenExpiry(), isNotNull);
    });

    test('falls back to the submitted email when the JWT has no email claim',
        () async {
      final accessToken = _fakeJwt({
        'unique_name': 'Nour',
        'nameid': 'user-1',
      });
      apiService.succeed(
        'login',
        _envelope(
          data: {
            'accessToken': accessToken,
            'refreshToken': 'refresh-1',
            'expiresIn': 3600,
          },
        ),
      );

      final user = await dataSource.login(email: email, password: password);

      expect(user.email, email);
      expect(user.firstName, 'Nour');
      expect(user.lastName, '');
    });

    test('skips empty refresh token and zero expiresIn', () async {
      final accessToken = _fakeJwt({'nameid': 'user-1'});
      apiService.succeed(
        'login',
        _envelope(
          data: {
            'accessToken': accessToken,
            'refreshToken': '',
            'expiresIn': 0,
          },
        ),
      );

      await dataSource.login(email: email, password: password);

      expect(await secureStorage.readToken(), accessToken);
      expect(await secureStorage.readRefreshToken(), isNull);
      expect(await secureStorage.readTokenExpiry(), isNull);
    });

    test('throws ApiException when the envelope reports a business failure',
        () async {
      apiService.succeed(
        'login',
        _envelope(
          status: false,
          errors: ['Invalid email or password.'],
          code: 401,
        ),
      );

      expect(
        () => dataSource.login(email: email, password: password),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 401)
              .having(
                (e) => e.message,
                'message',
                'Invalid email or password.',
              ),
        ),
      );
    });

    test('propagates whatever the API service throws', () async {
      apiService.fail('login', const InvalidCredentialsException());

      expect(
        () => dataSource.login(email: 'a@b.com', password: 'wrong'),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });
  });

  group('signUp', () {
    const signUpBody = {
      'fullName': 'Sara Ali',
      'email': 'sara@flowery.com',
      'phoneNumber': '01012345678',
      'gender': 2,
      'password': 'Password123',
      'confirmPassword': 'Password123',
    };

    test('returns a user built from the submitted fields, not invented',
        () async {
      apiService.succeed('signUp', _envelope(data: 'new-user-id', code: 201));

      final user = await dataSource.signUp(
        firstName: 'Sara',
        lastName: 'Ali',
        email: 'sara@flowery.com',
        password: 'Password123',
        confirmPassword: 'Password123',
        phoneNumber: '01012345678',
        gender: Gender.female,
      );

      expect(apiService.lastBodies['signUp'], signUpBody);
      expect(user.id, 'new-user-id');
      expect(user.firstName, 'Sara');
      expect(user.lastName, 'Ali');
      expect(user.email, 'sara@flowery.com');
      expect(user.phoneNumber, '01012345678');
      expect(user.gender, Gender.female);
      // Register never starts a session.
      expect(await secureStorage.readToken(), isNull);
    });

    test('sends the confirmed Gender wire mapping (male=1, female=2)',
        () async {
      apiService.succeed('signUp', _envelope(data: 'id'));

      await dataSource.signUp(
        firstName: 'A',
        lastName: 'B',
        email: 'a@b.com',
        password: 'Password123',
        confirmPassword: 'Password123',
        phoneNumber: '01000000000',
        gender: Gender.male,
      );

      expect(apiService.lastBodies['signUp']?['gender'], 1);
    });
  });

  group('continueAsGuest', () {
    test('clears any stored session and returns the guest user', () async {
      await secureStorage.saveToken('old-access');
      await secureStorage.saveRefreshToken('old-refresh');

      final user = await dataSource.continueAsGuest();

      expect(user.id, 'guest');
      expect(user.isGuest, isTrue);
      expect(await secureStorage.readToken(), isNull);
      expect(await secureStorage.readRefreshToken(), isNull);
    });
  });

  group('sendPasswordResetEmail', () {
    test('posts the email and completes when the envelope succeeds', () async {
      apiService.succeed('forgotPassword', _envelope());

      await dataSource.sendPasswordResetEmail('a@b.com');

      expect(apiService.lastBodies['forgotPassword'], {'email': 'a@b.com'});
      expect(apiService.callCounts['forgotPassword'], 1);
    });
  });

  group('verifyCode', () {
    test('returns the resetToken from the response envelope', () async {
      apiService.succeed(
        'verifyOtp',
        _envelope(data: {'resetToken': 'reset-token-123'}),
      );

      final resetToken = await dataSource.verifyCode(
        email: 'a@b.com',
        code: '1234',
      );

      expect(apiService.lastBodies['verifyOtp'], {
        'email': 'a@b.com',
        'otp': '1234',
      });
      expect(resetToken, 'reset-token-123');
    });

    test('returns an empty string when resetToken is absent', () async {
      apiService.succeed(
        'verifyOtp',
        _envelope(data: <String, dynamic>{}),
      );

      final resetToken = await dataSource.verifyCode(
        email: 'a@b.com',
        code: '1234',
      );

      expect(resetToken, '');
    });

    test('propagates a wrong-code exception unchanged', () async {
      apiService.fail('verifyOtp', const InvalidVerificationCodeException());

      expect(
        () => dataSource.verifyCode(email: 'a@b.com', code: '0000'),
        throwsA(isA<InvalidVerificationCodeException>()),
      );
    });
  });

  group('resetPassword', () {
    const resetBody = {
      'resetToken': 'token-1',
      'newPassword': 'NewPassword123',
      'confirmNewPassword': 'NewPassword123',
    };

    test('posts the resetToken/newPassword/confirmNewPassword as-is',
        () async {
      apiService.succeed('resetPassword', _envelope());

      await dataSource.resetPassword(
        resetToken: 'token-1',
        newPassword: 'NewPassword123',
        confirmNewPassword: 'NewPassword123',
      );

      expect(apiService.lastBodies['resetPassword'], resetBody);
    });
  });

  group('refreshSession', () {
    test('throws InvalidSessionException when there is no refresh token',
        () async {
      expect(
        () => dataSource.refreshSession(),
        throwsA(isA<InvalidSessionException>()),
      );
      expect(apiService.callCounts['refreshToken'], isNull);
    });

    test('calls the API and persists the new session when one exists',
        () async {
      await secureStorage.saveRefreshToken('old-refresh');
      apiService.succeed(
        'refreshToken',
        _envelope(
          data: {
            'accessToken': 'new-access',
            'refreshToken': 'new-refresh',
            'expiresIn': 1800,
          },
        ),
      );

      await dataSource.refreshSession();

      expect(apiService.lastBodies['refreshToken'], {
        'refreshToken': 'old-refresh',
      });
      expect(await secureStorage.readToken(), 'new-access');
      expect(await secureStorage.readRefreshToken(), 'new-refresh');
      expect(await secureStorage.readTokenExpiry(), isNotNull);
    });
  });

  group('envelope failure mapping', () {
    test('prefers the first server error over the envelope message', () async {
      apiService.succeed(
        'forgotPassword',
        _envelope(
          status: false,
          errors: ['Email not found.', 'Second error'],
          message: 'ignored',
          code: 404,
        ),
      );

      expect(
        () => dataSource.sendPasswordResetEmail('a@b.com'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            'Email not found.',
          ),
        ),
      );
    });

    test('uses the envelope message when errors are empty', () async {
      apiService.succeed(
        'forgotPassword',
        _envelope(
          status: false,
          errors: const [],
          message: 'Something went wrong.',
          code: 400,
        ),
      );

      expect(
        () => dataSource.sendPasswordResetEmail('a@b.com'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            'Something went wrong.',
          ),
        ),
      );
    });

    test('defaults statusCode 400 and a generic message when both are absent',
        () async {
      apiService.succeed('forgotPassword', _envelope(status: false));

      expect(
        () => dataSource.sendPasswordResetEmail('a@b.com'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 400)
              .having((e) => e.message, 'message', 'Request failed.'),
        ),
      );
    });
  });
}
