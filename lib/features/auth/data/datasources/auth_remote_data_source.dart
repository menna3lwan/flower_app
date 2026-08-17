import '../../../../core/domain/entities/user_entity.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import 'auth_local_data_source.dart';

/// Marker interface distinguishing "the real backend" from
/// [AuthLocalDataSource]'s simulated implementation at the DI/type level,
/// while remaining structurally interchangeable with it (same methods —
/// see the NOTE on [AuthLocalDataSource]). `AuthRepositoryImpl` keeps
/// depending on [AuthLocalDataSource]; DI decides which concrete class —
/// [AuthLocalDataSourceImpl] or [AuthRemoteDataSourceImpl] — it receives.
abstract interface class AuthRemoteDataSource
    implements AuthLocalDataSource {}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient, this._secureStorage);

  final ApiClient _apiClient;
  final SecureStorageService _secureStorage;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) {
   
    throw UnimplementedError(
      'Login endpoint not confirmed by Backend yet. See '
      'docs/BACKEND_INTEGRATION_TODO.md.',
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
  }) {
    // CONFIRM WITH BACKEND: path, request body field names (including
    // whether `gender` is sent as an enum string, an int, or omitted),
    // and response shape.
    throw UnimplementedError(
      'Sign Up endpoint not confirmed by Backend yet. See '
      'docs/BACKEND_INTEGRATION_TODO.md.',
    );
  }

  @override
  Future<UserEntity> continueAsGuest() async {
    await _secureStorage.deleteToken();
    return const UserEntity(
      id: 'guest',
      firstName: 'Guest',
      lastName: '',
      email: '',
      isGuest: true,
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    // CONFIRM WITH BACKEND: path and whether the response carries any
    // useful payload (e.g. a reset-request id) or is just a 200/204.
    throw UnimplementedError(
      'Forgot Password endpoint not confirmed by Backend yet. See '
      'docs/BACKEND_INTEGRATION_TODO.md.',
    );
  }

  @override
  Future<void> verifyCode({required String email, required String code}) {
    // CONFIRM WITH BACKEND: path, whether the OTP is called "code" or
    // "otp" in the request body, and what an expired-vs-wrong-code error
    // looks like (same status code or different ones?).
    throw UnimplementedError(
      'OTP verification endpoint not confirmed by Backend yet. See '
      'docs/BACKEND_INTEGRATION_TODO.md.',
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) {
    // CONFIRM WITH BACKEND: path, and whether this call requires the
    // verified OTP/a reset token from the previous step to be re-sent
    // (the local simulated flow currently does not carry one forward).
    throw UnimplementedError(
      'Reset Password endpoint not confirmed by Backend yet. See '
      'docs/BACKEND_INTEGRATION_TODO.md.',
    );
  }
}
