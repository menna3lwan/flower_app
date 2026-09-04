import 'package:customer_app/core/storage/secure_storage_service.dart';

class FakeSecureStorageService implements SecureStorageService {
  String? _token;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  @override
  Future<void> saveToken(String token) async => _token = token;

  @override
  Future<String?> readToken() async => _token;

  @override
  Future<void> deleteToken() async => _token = null;

  @override
  Future<void> saveRefreshToken(String token) async => _refreshToken = token;

  @override
  Future<String?> readRefreshToken() async => _refreshToken;

  @override
  Future<void> deleteRefreshToken() async => _refreshToken = null;

  @override
  Future<void> saveTokenExpiry(DateTime expiry) async => _tokenExpiry = expiry;

  @override
  Future<DateTime?> readTokenExpiry() async => _tokenExpiry;

  @override
  Future<void> deleteTokenExpiry() async => _tokenExpiry = null;

  @override
  Future<void> clearSession() async {
    _token = null;
    _refreshToken = null;
    _tokenExpiry = null;
  }
}
