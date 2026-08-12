import 'package:shared/domain/entities/user_entity.dart';
import 'package:core/error/exceptions.dart';
import 'package:core/error/failures.dart';
import 'package:core/result/result.dart';
import 'package:core/storage/local_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource, this._localStorageService);

  final AuthLocalDataSource _dataSource;
  final LocalStorageService _localStorageService;

  static const String _accessTokenKey = 'auth_access_token';

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.login(email: email, password: password);
      await _localStorageService.setString(_accessTokenKey, 'placeholder-access-token-${user.id}');
      return Result.success(user);
    } on ServerException catch (e) {
      return Result.failure(AuthFailure(e.message));
    } catch (_) {
      return  Result.failure(UnexpectedFailure());
    }
  }

  @override
  Future<Result<UserEntity>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required Gender gender,
  }) async {
    try {
      final user = await _dataSource.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        gender: gender,
      );
      return Result.success(user);
    } on ServerException catch (e) {
      return Result.failure(AuthFailure(e.message));
    } catch (_) {
      return  Result.failure(UnexpectedFailure());
    }
  }

  @override
  Future<Result<UserEntity>> continueAsGuest() async {
    try {
      final user = await _dataSource.continueAsGuest();
      return Result.success(user);
    } catch (_) {
      return  Result.failure(UnexpectedFailure());
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      await _dataSource.sendPasswordResetEmail(email);
      return  Result.success(null);
    } catch (_) {
      return  Result.failure(UnexpectedFailure());
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dataSource.resetPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return  Result.success(null);
    } catch (_) {
      return  Result.failure(UnexpectedFailure());
    }
  }
}
