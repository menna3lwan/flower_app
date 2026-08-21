import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the auth session (access token, refresh token, and the access
/// token's expiry) in the platform keystore/keychain — never in
/// [LocalStorageService], which is plain unencrypted storage.
abstract interface class SecureStorageService {
  Future<void> saveToken(String token);
  Future<String?> readToken();
  Future<void> deleteToken();

  Future<void> saveRefreshToken(String token);
  Future<String?> readRefreshToken();
  Future<void> deleteRefreshToken();

  /// Absolute UTC instant the current access token stops being valid,
  /// derived from the login/refresh response's `expiresIn` (seconds).
  Future<void> saveTokenExpiry(DateTime expiry);
  Future<DateTime?> readTokenExpiry();
  Future<void> deleteTokenExpiry();

  /// Clears the whole session (access token, refresh token, expiry) in
  /// one call — used on logout and on "continue as guest".
  Future<void> clearSession();
}

class FlutterSecureStorageService implements SecureStorageService {
  const FlutterSecureStorageService([
    this._storage = const FlutterSecureStorage(),
  ]);

  final FlutterSecureStorage _storage;
  static const String _accessTokenKey = 'flowery_auth_access_token';
  static const String _refreshTokenKey = 'flowery_auth_refresh_token';
  static const String _tokenExpiryKey = 'flowery_auth_token_expiry';

  @override
  Future<void> saveToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  @override
  Future<String?> readToken() => _storage.read(key: _accessTokenKey);

  @override
  Future<void> deleteToken() => _storage.delete(key: _accessTokenKey);

  @override
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  @override
  Future<void> deleteRefreshToken() => _storage.delete(key: _refreshTokenKey);

  @override
  Future<void> saveTokenExpiry(DateTime expiry) => _storage.write(
        key: _tokenExpiryKey,
        value: expiry.toUtc().toIso8601String(),
      );

  @override
  Future<DateTime?> readTokenExpiry() async {
    final raw = await _storage.read(key: _tokenExpiryKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  @override
  Future<void> deleteTokenExpiry() => _storage.delete(key: _tokenExpiryKey);

  @override
  Future<void> clearSession() => Future.wait([
        deleteToken(),
        deleteRefreshToken(),
        deleteTokenExpiry(),
      ]);
}
