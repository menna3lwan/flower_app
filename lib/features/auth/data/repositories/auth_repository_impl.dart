import '../../../../core/domain/entities/user_entity.dart';
import 'package:customer_app/core/error/exceptions.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/core/storage/local_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource, this._localStorageService);

  final AuthLocalDataSource _dataSource;
  final LocalStorageService _localStorageService;

  static const String _accessTokenKey = 'auth_access_token';

  static Failure _mapException(Object error) => switch (error) {
        InvalidCredentialsException() => const InvalidCredentialsFailure(),
        InvalidVerificationCodeException() =>
          const InvalidVerificationCodeFailure(),
        EmailNotFoundException() => const NotFoundFailure(),
        NetworkException() => const NetworkFailure(),
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
    return _guard(() async {
      final user = await _dataSource.login(email: email, password: password);
      await _localStorageService.setString(
        _accessTokenKey,
        'placeholder-access-token-${user.id}',
      );
      return user;
    });
  }

  @override
  Future<Result<UserEntity>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required Gender gender,
  }) {
    return _guard(
      () => _dataSource.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
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
  Future<Result<void>> verifyCode({
    required String email,
    required String code,
  }) {
    return _guard(() => _dataSource.verifyCode(email: email, code: code));
  }

  @override
  Future<Result<void>> resetPassword({
    required String email,
    required String newPassword,
  }) {
    return _guard(
      () => _dataSource.resetPassword(email: email, newPassword: newPassword),
    );
  }
}
