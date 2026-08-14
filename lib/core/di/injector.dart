import 'package:get_it/get_it.dart';

import '../network/api_client.dart';
import '../network/network_info.dart';
import '../storage/local_storage_service.dart';

/// The single [GetIt] service locator instance for the app.
///
/// Presentation code never constructs a repository/data source/Cubit
/// directly — it asks `sl<T>()`. This is what lets `main.dart` (or a
/// widget test) swap a real implementation for a fake one without
/// touching feature code.
final GetIt sl = GetIt.instance;

/// Registers every **cross-feature, infrastructure-level** dependency:
/// network client, connectivity check, local storage.
///
/// Each feature owns and registers its own repositories/data
/// sources/Cubits from its own `di/<feature>_injector.dart` — keeping
/// that registration next to the feature it belongs to (rather than
/// piling every feature's bindings into this one file) is what keeps
/// this file readable as the app grows. Call the feature registrars
/// from here once those features exist; see `main.dart` for the current
/// bootstrap order.
Future<void> setupCoreDependencies() async {
  sl
    ..registerLazySingleton<NetworkInfo>(AlwaysOnlineNetworkInfo.new)
    ..registerLazySingleton<ApiClient>(UnimplementedApiClient.new)
    ..registerLazySingleton<LocalStorageService>(
        InMemoryLocalStorageService.new);
}
