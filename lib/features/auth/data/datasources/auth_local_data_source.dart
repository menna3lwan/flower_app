import '../../../../core/domain/entities/user_entity.dart';
import 'package:customer_app/core/error/exceptions.dart';

abstract interface class AuthLocalDataSource {
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

  /// Returns a `resetToken` the caller must pass to [resetPassword] —
  /// see [AuthRepository.verifyCode] for why.
  Future<String> verifyCode({required String email, required String code});

  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  });

  Future<void> refreshSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _simulatedLatency = Duration(milliseconds: 600);

  static const _validEmail = 'test@flowery.com';
  static const _validPassword = 'Password123';
  static const _validVerificationCode = '1234';
  static const _fakeResetToken = 'fake-local-reset-token';

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(_simulatedLatency);
    if (email.trim().toLowerCase() != _validEmail ||
        password != _validPassword) {
      throw const InvalidCredentialsException();
    }
    return const UserEntity(
      id: 'user-1',
      firstName: 'Nour',
      lastName: 'Mohamed',
      email: _validEmail,
    );
  }

  @override
  Future<UserEntity> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required Gender gender,
  }) async {
    await Future.delayed(_simulatedLatency);
    return UserEntity(
      id: 'user-1',
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      gender: gender,
    );
  }

  @override
  Future<UserEntity> continueAsGuest() async {
    await Future.delayed(_simulatedLatency);
    return const UserEntity(
      id: 'guest',
      firstName: 'Guest',
      lastName: '',
      email: '',
      isGuest: true,
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(_simulatedLatency);
  }

  @override
  Future<String> verifyCode({
    required String email,
    required String code,
  }) async {
    await Future.delayed(_simulatedLatency);
    if (code != _validVerificationCode) {
      throw const InvalidVerificationCodeException();
    }
    return _fakeResetToken;
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    await Future.delayed(_simulatedLatency);
  }

  @override
  Future<void> refreshSession() async {
    await Future.delayed(_simulatedLatency);
  }
}
