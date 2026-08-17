import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class SecureStorageService {
  Future<void> saveToken(String token);
  Future<String?> readToken();
  Future<void> deleteToken();
}

class FlutterSecureStorageService implements SecureStorageService {
  const FlutterSecureStorageService([
    this._storage = const FlutterSecureStorage(),
  ]);

  final FlutterSecureStorage _storage;
  static const String _accessTokenKey = 'flowery_auth_access_token';

  @override
  Future<void> saveToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  @override
  Future<String?> readToken() => _storage.read(key: _accessTokenKey);

  @override
  Future<void> deleteToken() => _storage.delete(key: _accessTokenKey);
}
