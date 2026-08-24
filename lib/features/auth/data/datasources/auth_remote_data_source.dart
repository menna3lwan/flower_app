import '../../../../core/domain/entities/user_entity.dart';

/// Contract for Auth's single, real data source — the production backend over Retrofit/Dio (see [AuthRemoteDataSourceImpl] in `auth_remote_data_source_impl.dart`). Every method only ever returns a value or throws (DioException / [ApiException] / one of this project's typed Auth exceptions) — never a [Result] itself; that translation happens centrally in `core/network/error_parser.dart`, called from [AuthRepositoryImpl].
abstract interface class AuthRemoteDataSource {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required Gender gender,
  });

  Future<UserEntity> continueAsGuest();

  Future<void> sendPasswordResetEmail(String email);

  /// Returns a `resetToken` the caller must pass to [resetPassword] — see [AuthRepository.verifyCode].
  Future<String> verifyCode({required String email, required String code});

  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  });

  Future<void> refreshSession();
}
