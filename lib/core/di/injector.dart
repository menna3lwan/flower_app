import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/api_client.dart';
import '../network/dio_client_factory.dart';
import '../network/network_info.dart';
import '../storage/local_storage_service.dart';
import '../storage/secure_storage_service.dart';


final GetIt sl = GetIt.instance;

Future<void> setupCoreDependencies() async {
  sl
    ..registerLazySingleton<NetworkInfo>(ConnectivityNetworkInfo.new)
    ..registerLazySingleton<LocalStorageService>(
        InMemoryLocalStorageService.new)
    ..registerLazySingleton<SecureStorageService>(
        FlutterSecureStorageService.new)
    ..registerLazySingleton<Dio>(
        () => createDioClient(sl<SecureStorageService>()))
    ..registerLazySingleton<ApiClient>(() => DioApiClient(sl<Dio>()));
}
