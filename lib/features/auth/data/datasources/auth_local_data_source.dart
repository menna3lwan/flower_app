import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/error/exceptions.dart';

/// Placeholder data source simulating latency with dummy data until a real remote/local implementation lands.
abstract interface class AuthLocalDataSource {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required Gender gender,
  });

  Future<UserEntity> continueAsGuest();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> resetPassword({
    required String currentPassword,
    required String newPassword,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _simulatedLatency = Duration(milliseconds: 600);

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    await Future.delayed(_simulatedLatency);
    if (email.trim().isEmpty || password.isEmpty) {
      throw const ServerException('Invalid credentials.');
    }
    return UserEntity(
      id: 'user-1',
      firstName: 'Nour',
      lastName: 'Mohamed',
      email: email,
    );
  }

  @override
  Future<UserEntity> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
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
  Future<void> resetPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(_simulatedLatency);
  }
}
