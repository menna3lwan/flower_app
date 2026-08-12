import 'package:core/di/injector.dart';
import 'package:core/storage/local_storage_service.dart';

import '../features/auth/data/datasources/auth_local_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import '../features/auth/presentation/cubit/login/login_cubit.dart';
import '../features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import '../features/auth/presentation/cubit/sign_up/sign_up_cubit.dart';

Future<void> setupAuthDependencies() async {
  sl
    ..registerLazySingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl.new)
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<AuthLocalDataSource>(), sl<LocalStorageService>()),
    )
    ..registerFactory<LoginCubit>(() => LoginCubit(sl<AuthRepository>()))
    ..registerFactory<SignUpCubit>(() => SignUpCubit(sl<AuthRepository>()))
    ..registerFactory<ForgotPasswordCubit>(() => ForgotPasswordCubit(sl<AuthRepository>()))
    ..registerFactory<ResetPasswordCubit>(() => ResetPasswordCubit(sl<AuthRepository>()));
}
