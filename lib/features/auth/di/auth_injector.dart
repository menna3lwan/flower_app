import '../../../core/di/injector.dart';
import '../data/datasources/auth_local_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../presentation/cubit/forgot_password/forgot_password_cubit.dart';
import '../presentation/cubit/login/login_cubit.dart';
import '../presentation/cubit/reset_password/reset_password_cubit.dart';
import '../presentation/cubit/sign_up/sign_up_cubit.dart';

/// Registers every dependency the auth feature owns; Cubits are factories so each screen gets a fresh instance.
void setupAuthDependencies() {
  sl
    ..registerLazySingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl.new)
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    ..registerFactory(() => LoginCubit(sl()))
    ..registerFactory(() => SignUpCubit(sl()))
    ..registerFactory(() => ForgotPasswordCubit(sl()))
    ..registerFactory(() => ResetPasswordCubit(sl()));
}
