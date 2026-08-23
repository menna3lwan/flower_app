import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:customer_app/core/domain/entities/user_entity.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:customer_app/features/auth/presentation/intent/auth_intent.dart';
import 'package:customer_app/features/auth/presentation/state/auth_state.dart';

import '../../support/auth_cubit_harness.dart';
import '../../support/mocks.dart';

const _user = UserEntity(
  id: 'user-1',
  firstName: 'Nour',
  lastName: 'Mohamed',
  email: 'test@flowery.com',
);

void main() {
  late MockAuthRepository repository;
  late AuthCubit cubit;

  setUp(() {
    repository = MockAuthRepository();
    // Wires the mock repository through the real use cases into a real
    // AuthCubit — the exact object graph Injectable assembles in the
    // app, minus DI itself. Exercises the real UseCase pass-through as
    // part of "Cubit state transitions" instead of hiding it behind six
    // separate use-case mocks.
    cubit = buildAuthCubit(repository);
  });

  group('AuthCubit — starts idle', () {
    test('every operation starts as OperationStatus.idle', () {
      expect(cubit.state, const AuthState());
      expect(cubit.state.loginState.isIdle, isTrue);
      expect(cubit.state.signUpState.isIdle, isTrue);
      expect(cubit.state.forgotPasswordState.isIdle, isTrue);
      expect(cubit.state.verifyOtpState.isIdle, isTrue);
      expect(cubit.state.resetPasswordState.isIdle, isTrue);
    });
  });

  group('login', () {
    test('goes idle -> loading -> success, leaving every other field idle',
        () async {
      when(repository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => const Result.success(_user));

      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.onIntent(
        const LoginRequested(email: 'test@flowery.com', password: 'Password123'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(states, hasLength(2));
      expect(states[0].loginState.isLoading, isTrue);
      expect(states[1].loginState.isSuccess, isTrue);
      expect(states[1].loginState.data, _user);
      // Nothing else moved.
      expect(states[1].signUpState.isIdle, isTrue);
      expect(states[1].verifyOtpState.isIdle, isTrue);
    });

    test('a rejected login carries the Failure, not a string', () async {
      when(repository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer(
        (_) async => const Result.failure(InvalidCredentialsFailure()),
      );

      await cubit.onIntent(
        const LoginRequested(email: 'test@flowery.com', password: 'wrong'),
      );

      expect(cubit.state.loginState.isFailure, isTrue);
      expect(cubit.state.loginState.failure, isA<InvalidCredentialsFailure>());
    });
  });

  group('guest login', () {
    test('resolves through the same loginState as a normal login', () async {
      const guest = UserEntity(
        id: 'guest',
        firstName: 'Guest',
        lastName: '',
        email: '',
        isGuest: true,
      );
      when(repository.continueAsGuest())
          .thenAnswer((_) async => const Result.success(guest));

      await cubit.onIntent(const GuestLoginRequested());

      expect(cubit.state.loginState.isSuccess, isTrue);
      expect(cubit.state.loginState.data!.isGuest, isTrue);
    });
  });

  group('sign up', () {
    test('success leaves signUpState successful with no payload', () async {
      when(repository.signUp(
        firstName: anyNamed('firstName'),
        lastName: anyNamed('lastName'),
        email: anyNamed('email'),
        password: anyNamed('password'),
        confirmPassword: anyNamed('confirmPassword'),
        phoneNumber: anyNamed('phoneNumber'),
        gender: anyNamed('gender'),
      )).thenAnswer((_) async => const Result.success(_user));

      await cubit.onIntent(
        const SignUpRequested(
          firstName: 'Nour',
          lastName: 'Mohamed',
          email: 'test@flowery.com',
          password: 'Password123',
          confirmPassword: 'Password123',
          phoneNumber: '01012345678',
          gender: Gender.female,
        ),
      );

      // Sign Up routes to Login, so no session/user is carried forward —
      // the created UserEntity is intentionally discarded.
      expect(cubit.state.signUpState.isSuccess, isTrue);
      expect(cubit.state.signUpState.data, isNull);
      expect(cubit.state.loginState.isIdle, isTrue);
    });

    test('an existing email surfaces ConflictFailure', () async {
      when(repository.signUp(
        firstName: anyNamed('firstName'),
        lastName: anyNamed('lastName'),
        email: anyNamed('email'),
        password: anyNamed('password'),
        confirmPassword: anyNamed('confirmPassword'),
        phoneNumber: anyNamed('phoneNumber'),
        gender: anyNamed('gender'),
      )).thenAnswer((_) async => const Result.failure(ConflictFailure()));

      await cubit.onIntent(
        const SignUpRequested(
          firstName: 'Nour',
          lastName: 'Mohamed',
          email: 'test@flowery.com',
          password: 'Password123',
          confirmPassword: 'Password123',
          phoneNumber: '01012345678',
          gender: Gender.female,
        ),
      );

      expect(cubit.state.signUpState.isFailure, isTrue);
      expect(cubit.state.signUpState.failure, isA<ConflictFailure>());
    });
  });

  group('forgot password', () {
    test('success carries the submitted email forward as the payload',
        () async {
      when(repository.sendPasswordResetEmail(any))
          .thenAnswer((_) async => const Result.success(null));

      await cubit.onIntent(const ForgotPasswordRequested('test@flowery.com'));

      expect(cubit.state.forgotPasswordState.isSuccess, isTrue);
      expect(cubit.state.forgotPasswordState.data, 'test@flowery.com');
    });

    test('an unknown email surfaces NotFoundFailure', () async {
      when(repository.sendPasswordResetEmail(any))
          .thenAnswer((_) async => const Result.failure(NotFoundFailure()));

      await cubit.onIntent(const ForgotPasswordRequested('nobody@x.com'));

      expect(cubit.state.forgotPasswordState.isFailure, isTrue);
      expect(cubit.state.forgotPasswordState.failure, isA<NotFoundFailure>());
    });
  });

  group('verify otp', () {
    test('success carries the resetToken forward as the payload', () async {
      when(repository.verifyCode(
        email: anyNamed('email'),
        code: anyNamed('code'),
      )).thenAnswer((_) async => const Result.success('reset-token-123'));

      await cubit.onIntent(
        const VerifyCodeRequested(email: 'test@flowery.com', code: '1234'),
      );

      expect(cubit.state.verifyOtpState.isSuccess, isTrue);
      expect(cubit.state.verifyOtpState.data, 'reset-token-123');
    });

    test('a wrong/expired code surfaces InvalidVerificationCodeFailure',
        () async {
      when(repository.verifyCode(
        email: anyNamed('email'),
        code: anyNamed('code'),
      )).thenAnswer(
        (_) async => const Result.failure(InvalidVerificationCodeFailure()),
      );

      await cubit.onIntent(
        const VerifyCodeRequested(email: 'test@flowery.com', code: '9999'),
      );

      expect(cubit.state.verifyOtpState.isFailure, isTrue);
      expect(
        cubit.state.verifyOtpState.failure,
        isA<InvalidVerificationCodeFailure>(),
      );
      // Resend (forgotPasswordState) and verify (verifyOtpState) are
      // tracked independently — a verify failure must not touch the
      // resend slot.
      expect(cubit.state.forgotPasswordState.isIdle, isTrue);
    });
  });

  group('reset password', () {
    test('passes the verified resetToken to the repository unchanged',
        () async {
      when(repository.resetPassword(
        resetToken: anyNamed('resetToken'),
        newPassword: anyNamed('newPassword'),
        confirmNewPassword: anyNamed('confirmNewPassword'),
      )).thenAnswer((_) async => const Result.success(null));

      await cubit.onIntent(
        const ResetPasswordRequested(
          resetToken: 'reset-token-123',
          newPassword: 'NewPassword123',
          confirmNewPassword: 'NewPassword123',
        ),
      );

      expect(cubit.state.resetPasswordState.isSuccess, isTrue);
      verify(repository.resetPassword(
        resetToken: 'reset-token-123',
        newPassword: 'NewPassword123',
        confirmNewPassword: 'NewPassword123',
      )).called(1);
    });

    test('an expired reset link surfaces NotFoundFailure', () async {
      when(repository.resetPassword(
        resetToken: anyNamed('resetToken'),
        newPassword: anyNamed('newPassword'),
        confirmNewPassword: anyNamed('confirmNewPassword'),
      )).thenAnswer((_) async => const Result.failure(NotFoundFailure()));

      await cubit.onIntent(
        const ResetPasswordRequested(
          resetToken: 'expired',
          newPassword: 'NewPassword123',
          confirmNewPassword: 'NewPassword123',
        ),
      );

      expect(cubit.state.resetPasswordState.isFailure, isTrue);
    });
  });
}
