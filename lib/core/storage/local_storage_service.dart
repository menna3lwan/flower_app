/// Key-value local storage contract used for lightweight persistence
/// (auth token, "remember me" flag, onboarding-seen flag, ...).
///
/// [InMemoryLocalStorageService] is a placeholder that only lives for the
/// current app session — it is enough for the skeleton to demonstrate the
/// seam without adding a persistence package before any feature actually
/// needs durable storage. Swap in a `shared_preferences`/`hive`-backed
/// implementation later and register it in `core/di/injector.dart`; every
/// caller depends on this interface, not the concrete class.
abstract interface class LocalStorageService {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);

  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);

  Future<void> remove(String key);
  Future<void> clear();
}

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
