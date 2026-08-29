// Hand-authored stand-in for Injectable's generated config (no Dart/Flutter SDK in this sandbox) — run `dart run build_runner build --delete-conflicting-outputs` elsewhere to replace it for real.

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get_it/get_it.dart';

// Auth module.
import '../../features/auth/api/auth_api_service.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/auth/data/datasources/dev/local_test_auth_data_source.dart';
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

// Commerce module (shared catalog foundation + Home).
import '../../features/commerce/data/data_sources/local/catalog_local_data_source.dart';
import '../../features/commerce/data/data_sources/local/catalog_local_data_source_impl.dart';
import '../../features/commerce/data/repositories/catalog_repository_impl.dart';
import '../../features/commerce/domain/repositories/catalog_repository.dart';
import '../../features/commerce/domain/use_cases/get_best_sellers_use_case.dart';
import '../../features/commerce/domain/use_cases/get_categories_use_case.dart';
import '../../features/commerce/domain/use_cases/get_occasions_use_case.dart';
import '../../features/commerce/domain/use_cases/get_product_by_id_use_case.dart';
import '../../features/commerce/domain/use_cases/get_products_by_category_use_case.dart';
import '../../features/commerce/domain/use_cases/get_products_by_occasion_use_case.dart';
import '../../features/commerce/domain/use_cases/search_products_use_case.dart';
import '../../features/commerce/ui/home/manager/home_cubit.dart';

// Commerce module (Home / SDUI).
import '../../features/commerce/data/api/home_api_service.dart';
import '../../features/commerce/data/data_sources/remote/dev/local_mock_home_remote_data_source.dart';
import '../../features/commerce/data/data_sources/remote/home_remote_data_source.dart';
import '../../features/commerce/data/data_sources/remote/home_remote_data_source_impl.dart';
import '../../features/commerce/data/repositories/home_repository_impl.dart';
import '../../features/commerce/di/home_module.dart';
import '../../features/commerce/domain/repositories/home_repository.dart';
import '../../features/commerce/domain/use_cases/get_home_sections_use_case.dart';
import '../../features/commerce/domain/use_cases/load_home_use_case.dart';
import '../../features/commerce/ui/home/registry/home_section_renderer_registry.dart';

import '../storage/secure_storage_service.dart';

/// Instantiates the abstract `@module` class so its provider method can be called, mirroring what the real generator does.
class _AuthApiModuleImpl extends AuthApiModule {}

/// Instantiates the abstract `@module` class so its provider method can be called, mirroring what the real generator does.
class _HomeApiModuleImpl extends HomeApiModule {}

extension GetItInjectableX on GetIt {
  /// Registers every `@injectable`/`@LazySingleton`/`@module` class; core deps are assumed already registered first.
  GetIt init() {
    // ---- Auth ----
    final authApiModule = _AuthApiModuleImpl();

    registerLazySingleton<AuthApiService>(
      () => authApiModule.authApiService(get<Dio>()),
    );

    // AuthRemoteDataSource is Auth's one and only data source — the real backend over Retrofit/Dio.
    // In debug builds only, it's wrapped by LocalTestAuthDataSource (a Decorator) so a single hardcoded
    // local account can reach Home etc. before the real backend exists, without touching this class,
    // AuthRepositoryImpl, or any use case/Cubit. Every other credential — and every build that isn't
    // debug — goes through AuthRemoteDataSourceImpl exactly as before. In release builds the `if`
    // below is compile-time false, so LocalTestAuthDataSource is dead-code-eliminated entirely.
    // NOTE: AuthRemoteDataSourceImpl still carries @LazySingleton(as: AuthRemoteDataSource) from the
    // earlier refactor. This file is hand-authored (see header), so that annotation is inert today —
    // but if this project ever switches to a real `build_runner`-generated config, this manual
    // debug/release branch must be ported over (or the annotation removed) so the real generator
    // doesn't silently re-bind AuthRemoteDataSourceImpl directly and drop this gate.
    registerLazySingleton<AuthRemoteDataSource>(() {
      final realDataSource = AuthRemoteDataSourceImpl(
        get<AuthApiService>(),
        get<SecureStorageService>(),
      );
      if (kDebugMode) {
        return LocalTestAuthDataSource(realDataSource);
      }
      return realDataSource;
    });

    registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(get<AuthRemoteDataSource>()),
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

    // ---- Commerce (shared catalog foundation) ---- no remote data source/API module yet since no real catalog backend contract exists.
    registerLazySingleton<CatalogLocalDataSource>(
      CatalogLocalDataSourceImpl.new,
    );

    registerLazySingleton<CatalogRepository>(
      () => CatalogRepositoryImpl(get<CatalogLocalDataSource>()),
    );

    registerLazySingleton<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(get<CatalogRepository>()),
    );
    registerLazySingleton<GetOccasionsUseCase>(
      () => GetOccasionsUseCase(get<CatalogRepository>()),
    );
    registerLazySingleton<GetBestSellersUseCase>(
      () => GetBestSellersUseCase(get<CatalogRepository>()),
    );
    registerLazySingleton<GetProductsByCategoryUseCase>(
      () => GetProductsByCategoryUseCase(get<CatalogRepository>()),
    );
    registerLazySingleton<GetProductsByOccasionUseCase>(
      () => GetProductsByOccasionUseCase(get<CatalogRepository>()),
    );
    registerLazySingleton<GetProductByIdUseCase>(
      () => GetProductByIdUseCase(get<CatalogRepository>()),
    );
    registerLazySingleton<SearchProductsUseCase>(
      () => SearchProductsUseCase(get<CatalogRepository>()),
    );

    // ---- Commerce: Home (SDUI) ---- section list/order is real remote data; section content still reuses the Catalog use cases above.
    final homeApiModule = _HomeApiModuleImpl();

    registerLazySingleton<HomeApiService>(
      () => homeApiModule.homeApiService(get<Dio>()),
    );

    // The real Commerce Home API still doesn't exist (see docs/BACKEND_INTEGRATION_TODO.md), so in
    // debug builds only, HomeRemoteDataSource resolves to LocalMockHomeRemoteDataSource instead of
    // the real Retrofit-backed impl — same contract, zero network calls, and dead-code-eliminated
    // from release builds since `kDebugMode` is compile-time false there. HomeRepositoryImpl, every
    // use case, and HomeCubit are untouched either way; only this registration branches. Swap back to
    // the real API by deleting this `if` once the backend is live — no other file needs to change.
    registerLazySingleton<HomeRemoteDataSource>(() {
      if (kDebugMode) {
        return LocalMockHomeRemoteDataSource();
      }
      return HomeRemoteDataSourceImpl(get<HomeApiService>());
    });

    registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(get<HomeRemoteDataSource>()),
    );

    registerLazySingleton<GetHomeSectionsUseCase>(
      () => GetHomeSectionsUseCase(get<HomeRepository>()),
    );

    registerLazySingleton<LoadHomeUseCase>(
      () => LoadHomeUseCase(
        get<GetHomeSectionsUseCase>(),
        get<GetCategoriesUseCase>(),
        get<GetOccasionsUseCase>(),
        get<GetBestSellersUseCase>(),
        get<GetProductsByOccasionUseCase>(),
        get<GetProductsByCategoryUseCase>(),
      ),
    );

    registerLazySingleton<HomeSectionRendererRegistry>(
      HomeSectionRendererRegistry.new,
    );

    registerFactory<HomeCubit>(
      () => HomeCubit(get<LoadHomeUseCase>()),
    );

    return this;
  }
}
