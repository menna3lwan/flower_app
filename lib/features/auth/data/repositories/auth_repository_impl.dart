import '../../../../core/domain/entities/user_entity.dart';
import 'package:customer_app/core/error/exceptions.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthLocalDataSource _dataSource;

  static Failure _mapException(Object error) => switch (error) {
        InvalidCredentialsException() => const InvalidCredentialsFailure(),
        InvalidVerificationCodeException() =>
          const InvalidVerificationCodeFailure(),
        InvalidSessionException() => const AuthFailure(),
        EmailNotFoundException() => const NotFoundFailure(),
        NetworkException() => const NetworkFailure(),
        ApiException(:final statusCode, :final message)
            when statusCode == 400 || statusCode == 422 =>
          ValidationFailure(message),
        ApiException(:final statusCode, :final message)
            when statusCode == 401 || statusCode == 403 =>
          AuthFailure(message),
        ApiException(:final statusCode, :final message)
            when statusCode == 404 =>
          NotFoundFailure(message),
        ApiException(:final statusCode, :final message)
            when statusCode == 409 =>
          ConflictFailure(message),
        ApiException(:final statusCode, :final message)
            when statusCode >= 500 =>
          ServerFailure(message),
        ApiException(:final message) => ServerFailure(message),
        ServerException() => const ServerFailure(),
        CacheException() => const ServerFailure(),
        _ => const UnexpectedFailure(),
      };

  Future<Result<T>> _guard<T>(Future<T> Function() operation) async {
    try {
      return Result.success(await operation());
    } catch (error) {
      return Result.failure(_mapException(error));
    }
  }

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) {
    return _guard(() => _dataSource.login(email: email, password: password));
  }

  @override
  Future<Result<UserEntity>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required Gender gender,
  }) {
    return _guard(
      () => _dataSource.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
        gender: gender,
      ),
    );
  }

  @override
  Future<Result<UserEntity>> continueAsGuest() {
    return _guard(() => _dataSource.continueAsGuest());
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) {
    return _guard(() => _dataSource.sendPasswordResetEmail(email));
  }

  @override
  Future<Result<String>> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      final result = await _dataSource.verifyCode(email: email, code: code);
      return Result.success(result);
    } on ServerException catch (e) {
      return Result.failure(AuthFailure(e.message));
    } catch (_) {
      return Result.failure(UnexpectedFailure());
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  }) {
    return _guard(
      () => _dataSource.resetPassword(
        resetToken: resetToken,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      ),
    );
  }

  @override
  Future<Result<void>> refreshSession() {
    return _guard(() => _dataSource.refreshSession());
  }
}
