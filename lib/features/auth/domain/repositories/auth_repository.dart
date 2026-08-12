import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/result/result.dart';

/// Contract the presentation layer depends on, never a concrete impl or data source directly (DIP).
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

  Future<Result<void>> resetPassword({
    required String currentPassword,
    required String newPassword,
  });
}
