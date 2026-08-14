import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/core/domain/entities/user_entity.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:customer_app/features/auth/presentation/intent/auth_intent.dart';
import 'package:customer_app/features/auth/presentation/state/auth_state.dart';

import '../../support/fake_auth_repository.dart';

void main() {
  group('AuthCubit', () {
    test('starts in AuthInitial', () {
      expect(AuthCubit(FakeAuthRepository()).state, const AuthInitial());
    });

    test('login emits Loading then AuthLoginSuccess with the user', () async {
      final cubit = AuthCubit(
        FakeAuthRepository(loginResult: const Result.success(testUser)),
      );
      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.onIntent(
        const LoginRequested(
            email: 'test@flowery.com', password: 'Password123'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(states, [const AuthLoading(), const AuthLoginSuccess(testUser)]);
    });

    test('login emits AuthFailed carrying the Failure, not a string', () async {
      final cubit = AuthCubit(
        FakeAuthRepository(
          loginResult: const Result.failure(InvalidCredentialsFailure()),
        ),
      );
      final states = <AuthState>[];
      cubit.stream.listen(states.add);

      await cubit.onIntent(
        const LoginRequested(email: 'test@flowery.com', password: 'wrong'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(states.last, isA<AuthFailed>());
      expect(
        (states.last as AuthFailed).failure,
        isA<InvalidCredentialsFailure>(),
      );
    });

    test('guest login resolves to AuthLoginSuccess', () async {
      final cubit = AuthCubit(FakeAuthRepository());

      await cubit.onIntent(const GuestLoginRequested());

      expect(cubit.state, isA<AuthLoginSuccess>());
      expect((cubit.state as AuthLoginSuccess).user.isGuest, isTrue);
    });

    test('sign up emits a payload-free AuthSignUpSuccess', () async {
      final cubit = AuthCubit(
        FakeAuthRepository(signUpResult: const Result.success(testUser)),
      );

      await cubit.onIntent(
        const SignUpRequested(
          firstName: 'Nour',
          lastName: 'Mohamed',
          email: 'test@flowery.com',
          password: 'Password123',
          phoneNumber: '01012345678',
          gender: Gender.female,
        ),
      );

      // Sign Up routes to Login, so no session/user is carried forward.
      expect(cubit.state, const AuthSignUpSuccess());
    });

    test('forgot password carries the email forward', () async {
      final cubit = AuthCubit(
        FakeAuthRepository(
            sendPasswordResetEmailResult: const Result.success(null)),
      );

      await cubit.onIntent(const ForgotPasswordRequested('test@flowery.com'));

      expect(cubit.state, const AuthPasswordResetEmailSent('test@flowery.com'));
    });

    test('verify code carries the email into AuthCodeVerified', () async {
      final cubit = AuthCubit(
        FakeAuthRepository(verifyCodeResult: const Result.success(null)),
      );

      await cubit.onIntent(
        const VerifyCodeRequested(email: 'test@flowery.com', code: '1234'),
      );

      // Reset Password needs this email — losing it here would strand the
      // last step of the flow.
      expect(cubit.state, const AuthCodeVerified('test@flowery.com'));
    });

    test('an invalid code surfaces InvalidVerificationCodeFailure', () async {
      final cubit = AuthCubit(
        FakeAuthRepository(
          verifyCodeResult:
              const Result.failure(InvalidVerificationCodeFailure()),
        ),
      );

      await cubit.onIntent(
        const VerifyCodeRequested(email: 'test@flowery.com', code: '9999'),
      );

      expect(
        (cubit.state as AuthFailed).failure,
        isA<InvalidVerificationCodeFailure>(),
      );
    });

    test('reset password passes the verified email to the repository',
        () async {
      final repository =
          FakeAuthRepository(resetPasswordResult: const Result.success(null));
      final cubit = AuthCubit(repository);

      await cubit.onIntent(
        const ResetPasswordRequested(
          email: 'test@flowery.com',
          newPassword: 'NewPassword123',
        ),
      );

      expect(cubit.state, const AuthPasswordResetSuccess());
      expect(repository.lastResetPasswordEmail, 'test@flowery.com');
    });
  });
}
