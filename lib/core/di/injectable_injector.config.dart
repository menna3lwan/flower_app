// Hand-authored stand-in for Injectable's generated registration file —
// see `features/auth/api/auth_api_service.g.dart`'s header comment for
// why (this sandbox can't run `dart run build_runner build`).
//
// Behaviorally equivalent to what `injectable_generator` would emit for
// the `@injectable` / `@LazySingleton` / `@module` annotations declared
// across `features/auth/**`: the same GetIt registration calls, the same
// singleton/factory semantics — `AuthApiService`, the data source, the
// repository, and every use case as lazy singletons; `AuthCubit` as a
// factory (a fresh instance per `BlocProvider`, matching the old
// `registerFactory<AuthCubit>` call in the now-retired
// `core/di/auth_injector.dart`) — just written by hand instead of
// generated from those annotations.
//
// Run `dart run build_runner build --delete-conflicting-outputs` to
// replace this file with the real generated one; nothing outside this
// file needs to change when that happens — every caller only ever calls
// `configureAuthDependencies(sl)` (`injectable_injector.dart`), never
// anything in here directly.

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/api/auth_api_service.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/di/auth_module.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/continue_as_guest_usecase.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../storage/secure_storage_service.dart';

/// `@module`-provided types (see `AuthApiModule`) don't have their own
/// constructor Injectable can call directly — the real generator
/// instantiates the module class itself (here, a trivial subclass, since
/// `AuthApiModule` is abstract) and calls its provider method. Mirrored
/// here for the same reason.
class _AuthApiModuleImpl extends AuthApiModule {}

extension GetItInjectableX on GetIt {
  /// Registers every Auth-module dependency — replaces the old manual
  /// `setupAuthDependencies()` in the now-retired
  /// `core/di/auth_injector.dart`. Core-level dependencies ([Dio],
  /// [SecureStorageService], ...) are assumed already registered by
  /// `core/di/injector.dart`'s `setupCoreDependencies()`, which still
  /// runs first — see `core/di/customer_app_injector.dart`.
  GetIt init() {
    final authApiModule = _AuthApiModuleImpl();

    registerLazySingleton<AuthApiService>(
      () => authApiModule.authApiService(get<Dio>()),
    );

    // AuthLocalDataSourceImpl (the offline fake) is deliberately NOT
    // registered here — the app always talks to the real backend via
    // AuthRemoteDataSourceImpl, and tests construct FakeAuthRepository
    // directly rather than resolving a data source from GetIt. Two
    // unnamed registrations for the same AuthLocalDataSource interface
    // would be ambiguous to GetIt, so only the active implementation is
    // registered — same behavior as the old manual injector's
    // "ACTIVATION SWITCH" comment described.
    registerLazySingleton<AuthLocalDataSource>(
      () => AuthRemoteDataSourceImpl(
        get<AuthApiService>(),
        get<SecureStorageService>(),
      ),
    );

    registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(get<AuthLocalDataSource>()),
    );

    registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(get<AuthRepository>()),
    );
    registerLazySingleton<ContinueAsGuestUseCase>(
      () => ContinueAsGuestUseCase(get<AuthRepository>()),
    );
    registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(get<AuthRepository>()),
    );
    registerLazySingleton<ForgotPasswordUseCase>(
      () => ForgotPasswordUseCase(get<AuthRepository>()),
    );
    registerLazySingleton<VerifyOtpUseCase>(
      () => VerifyOtpUseCase(get<AuthRepository>()),
    );
    registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(get<AuthRepository>()),
    );

    registerFactory<AuthCubit>(
      () => AuthCubit(
        get<LoginUseCase>(),
        get<ContinueAsGuestUseCase>(),
        get<SignUpUseCase>(),
        get<ForgotPasswordUseCase>(),
        get<VerifyOtpUseCase>(),
        get<ResetPasswordUseCase>(),
      ),
    );

    return this;
  }
}
