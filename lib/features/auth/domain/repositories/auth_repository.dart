import '../../../../core/domain/entities/user_entity.dart';
import 'package:customer_app/core/result/result.dart';

abstract interface class AuthRepository {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required Gender gender,
  });

  Future<Result<UserEntity>> continueAsGuest();

  Future<Result<void>> sendPasswordResetEmail(String email);

  /// Confirms the code sent by [sendPasswordResetEmail] to `email`.
  Future<Result<void>> verifyCode({
    required String email,
    required String code,
  });

  Future<Result<void>> resetPassword({
    required String currentPassword,
    required String newPassword,
  });
}
