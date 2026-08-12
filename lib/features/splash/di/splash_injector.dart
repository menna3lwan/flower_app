import '../../../core/di/injector.dart';
import '../data/repositories/splash_repository_impl.dart';
import '../domain/repositories/splash_repository.dart';
import '../presentation/cubit/splash_cubit.dart';

/// Registers the splash feature's repository and Cubit; depends on `LocalStorageService`, so must run after core.
void setupSplashDependencies() {
  sl
    ..registerLazySingleton<SplashRepository>(() => SplashRepositoryImpl(sl()))
    ..registerFactory(() => SplashCubit(sl()));
}
