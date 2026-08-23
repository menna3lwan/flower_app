import 'package:injectable/injectable.dart';

import '../../../../core/base/safe_call.dart';
import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

/// Every method here is a one-line `safeCall(...)` wrapper around the
/// data source — no `try`/`catch`, no manual exception-to-[Failure]
/// switch. That mapping used to live in this class's own private
/// `_guard`/`_mapException` pair; it now lives once, centrally, in
/// `core/base/safe_call.dart` + `core/network/error_parser.dart`, so
/// every future repository in the app gets the exact same error handling
/// for free instead of re-implementing it.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthLocalDataSource _dataSource;

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) {
    return safeCall(() => _dataSource.login(email: email, password: password));
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
    return safeCall(
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
    return safeCall(() => _dataSource.continueAsGuest());
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) {
    return safeCall(() => _dataSource.sendPasswordResetEmail(email));
  }

  @override
  Future<Result<String>> verifyCode({
    required String email,
    required String code,
  }) {
    return safeCall(() => _dataSource.verifyCode(email: email, code: code));
  }

  @override
  Future<Result<void>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  }) {
    return safeCall(
      () => _dataSource.resetPassword(
        resetToken: resetToken,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      ),
    );
  }

  @override
  Future<Result<void>> refreshSession() {
    return safeCall(() => _dataSource.refreshSession());
  }
}
