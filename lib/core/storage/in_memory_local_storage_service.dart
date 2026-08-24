import 'local_storage_service.dart';

class InMemoryLocalStorageService implements LocalStorageService {
  final Map<String, Object> _store = {};

  @override
  Future<void> setString(String key, String value) async => _store[key] = value;

  @override
  Future<String?> getString(String key) async => _store[key] as String?;

  @override
  Future<void> setBool(String key, bool value) async => _store[key] = value;

  @override
  Future<bool?> getBool(String key) async => _store[key] as bool?;

  @override
  Future<void> remove(String key) async => _store.remove(key);

  @override
  Future<void> clear() async => _store.clear();
}
