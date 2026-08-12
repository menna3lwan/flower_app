import 'package:get_it/get_it.dart';

import '../localization/locale_controller.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../storage/local_storage_service.dart';

/// The single [GetIt] service locator instance — presentation code asks `sl<T>()`, never constructs directly.
final GetIt sl = GetIt.instance;

/// Registers cross-feature infrastructure only; each feature registers its own bindings from its own injector.
Future<void> setupCoreDependencies() async {
  sl
    ..registerLazySingleton<NetworkInfo>(AlwaysOnlineNetworkInfo.new)
    ..registerLazySingleton<ApiClient>(UnimplementedApiClient.new)
    ..registerLazySingleton<LocalStorageService>(InMemoryLocalStorageService.new)
    ..registerLazySingleton<LocaleController>(() => LocaleController(sl()));
}
