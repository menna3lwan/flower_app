import 'package:customer_app/core/di/injector.dart';
import 'package:customer_app/core/network/api_client.dart';
import 'package:customer_app/core/storage/secure_storage_service.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

Future<void> setupAuthDependencies() async {
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
          sl<ApiClient>(), sl<SecureStorageService>()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl.new)
    // ACTIVATION SWITCH: the real backend (docker/docker-compose.yml,
    // FlowersApp.Auth through the API Gateway) is confirmed reachable and
    // its full endpoint contract is confirmed (docker/auth-swagger.json,
    // Login/SignUp/ForgotPassword/VerifyOtp/ResetPassword all tested live
    // with curl through the Gateway) — so `AuthRepository` now binds to
    // `AuthRemoteDataSource`, not the in-memory `AuthLocalDataSource`.
    // Flip this one line back to `sl<AuthLocalDataSource>()` to fall back
    // to the offline fake (e.g. for widget tests without a backend).
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
    )
    ..registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));
}
