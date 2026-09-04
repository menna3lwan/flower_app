/// Persists the auth session in the platform keystore/keychain — never in [LocalStorageService], which is unencrypted. [FlutterSecureStorageService] (in `flutter_secure_storage_service.dart`) is the production implementation.
abstract interface class SecureStorageService {
  Future<void> saveToken(String token);
  Future<String?> readToken();
  Future<void> deleteToken();

  Future<void> saveRefreshToken(String token);
  Future<String?> readRefreshToken();
  Future<void> deleteRefreshToken();

  /// Absolute UTC instant the current access token stops being valid, derived from the login/refresh response's `expiresIn`.
  Future<void> saveTokenExpiry(DateTime expiry);
  Future<DateTime?> readTokenExpiry();
  Future<void> deleteTokenExpiry();

  /// Clears the whole session (token, refresh token, expiry) in one call — used on logout and "continue as guest".
  Future<void> clearSession();
}
