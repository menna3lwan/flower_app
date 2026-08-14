import 'package:customer_app/core/di/injector.dart';
import 'package:customer_app/core/storage/local_storage_service.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

Future<void> setupAuthDependencies() async {
  sl
    ..registerLazySingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl.new)
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
          sl<AuthLocalDataSource>(), sl<LocalStorageService>()),
    )
    ..registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));
}
