// Hand-authored stand-in for Injectable's generated config (no Dart/Flutter SDK in this sandbox) — run `dart run build_runner build --delete-conflicting-outputs` elsewhere to replace it for real.

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Auth module.
import '../../features/auth/api/auth_api_service.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart';
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

import '../storage/secure_storage_service.dart';

/// Instantiates the abstract `@module` class so its provider method can be called, mirroring what the real generator does.
class _AuthApiModuleImpl extends AuthApiModule {}

extension GetItInjectableX on GetIt {
  /// Registers every `@injectable`/`@LazySingleton`/`@module` class; core deps are assumed already registered first.
  GetIt init() {
    // ---- Auth ----
    final authApiModule = _AuthApiModuleImpl();

    registerLazySingleton<AuthApiService>(
      () => authApiModule.authApiService(get<Dio>()),
    );

    // AuthRemoteDataSource is Auth's one and only data source — the real backend over Retrofit/Dio. There is no dummy/local implementation to accidentally wire up anymore.
    registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        get<AuthApiService>(),
        get<SecureStorageService>(),
      ),
    );

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

    // ---- Commerce: Home ----
    registerFactory<HomeCubit>(
      () => HomeCubit(
        get<GetCategoriesUseCase>(),
        get<GetBestSellersUseCase>(),
        get<GetOccasionsUseCase>(),
      ),
    );

    return this;
  }
}
