import '../../../../core/domain/entities/user_entity.dart';
import 'package:customer_app/core/result/result.dart';

/// Contract the presentation layer (auth Cubits) depends on.
///
/// The presentation and domain layers only ever see this abstract
/// definition — never [AuthRepositoryImpl] or a data source directly.
/// That indirection is what lets the data layer swap an in-memory
/// placeholder for a real REST/Firebase implementation later without
/// touching a single Cubit.
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
