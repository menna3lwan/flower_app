/// Key-value local storage contract; [InMemoryLocalStorageService] (in `in_memory_local_storage_service.dart`) is a session-only placeholder until a durable implementation is needed.
abstract interface class LocalStorageService {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);

  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);

  Future<void> remove(String key);
  Future<void> clear();
}
