import 'package:customer_app/core/domain/entities/user_entity.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/features/auth/domain/repositories/auth_repository.dart';

const UserEntity testUser = UserEntity(
  id: 'user-1',
  firstName: 'Nour',
  lastName: 'Mohamed',
  email: 'test@flowery.com',
);

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.loginResult,
    this.signUpResult,
    this.sendPasswordResetEmailResult,
    this.verifyCodeResult,
    this.resetPasswordResult,
  });

  final Result<UserEntity>? loginResult;
  final Result<UserEntity>? signUpResult;
  final Result<void>? sendPasswordResetEmailResult;
  final Result<void>? verifyCodeResult;
  final Result<void>? resetPasswordResult;

  String? lastResetPasswordEmail;
  String? lastVerifiedEmail;

  static Future<T> _pending<T>() => Future<T>.delayed(const Duration(days: 1));

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async =>
      loginResult ?? _pending();

  @override
  Future<Result<UserEntity>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required Gender gender,
  }) async =>
      signUpResult ?? _pending();

  @override
  Future<Result<UserEntity>> continueAsGuest() async => const Result.success(
        UserEntity(
          id: 'guest',
          firstName: 'Guest',
          lastName: '',
          email: '',
          isGuest: true,
        ),
      );

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async =>
      sendPasswordResetEmailResult ?? _pending();

  @override
  Future<Result<void>> verifyCode({
    required String email,
    required String code,
  }) async {
    lastVerifiedEmail = email;
    return verifyCodeResult ?? _pending();
  }

  @override
  Future<Result<void>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    lastResetPasswordEmail = email;
    return resetPasswordResult ?? _pending();
  }
}
