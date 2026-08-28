// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/api/auth_api_service.dart' as _i299;
import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart'
    as _i123;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/di/auth_module.dart' as _i433;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/continue_as_guest_usecase.dart'
    as _i69;
import '../../features/auth/domain/usecases/forgot_password_usecase.dart'
    as _i560;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/reset_password_usecase.dart'
    as _i474;
import '../../features/auth/domain/usecases/sign_up_usecase.dart' as _i860;
import '../../features/auth/domain/usecases/verify_otp_usecase.dart' as _i503;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/commerce/data/data_sources/local/catalog_local_data_source.dart'
    as _i228;
import '../../features/commerce/data/data_sources/local/catalog_local_data_source_impl.dart'
    as _i624;
import '../../features/commerce/data/data_sources/remote/catalog_remote_data_source.dart'
    as _i204;
import '../../features/commerce/data/data_sources/remote/catalog_remote_data_source_impl.dart'
    as _i790;
import '../../features/commerce/data/mappers/commerce_mapper.dart' as _i660;
import '../../features/commerce/data/repositories/catalog_repository_impl.dart'
    as _i973;
import '../../features/commerce/domain/repositories/catalog_repository.dart'
    as _i896;
import '../../features/commerce/domain/use_cases/get_all_products_use_case.dart'
    as _i282;
import '../../features/commerce/domain/use_cases/get_best_sellers_use_case.dart'
    as _i498;
import '../../features/commerce/domain/use_cases/get_categories_use_case.dart'
    as _i148;
import '../../features/commerce/domain/use_cases/get_occasions_use_case.dart'
    as _i448;
import '../../features/commerce/domain/use_cases/get_product_by_id_use_case.dart'
    as _i44;
import '../../features/commerce/domain/use_cases/get_products_by_category_use_case.dart'
    as _i946;
import '../../features/commerce/domain/use_cases/get_products_by_occasion_use_case.dart'
    as _i874;
import '../../features/commerce/domain/use_cases/search_products_use_case.dart'
    as _i711;
import '../../features/commerce/ui/best_seller/manager/cubit/best_seller_cubit.dart'
    as _i680;
import '../../features/commerce/ui/categories/manager/cubit/categories_cubit.dart'
    as _i446;
import '../../features/commerce/ui/home/manager/home_cubit.dart' as _i20;
import '../../features/commerce/ui/product_details/manager/cubit/product_details_cubit.dart'
    as _i525;
import '../storage/secure_storage_service.dart' as _i666;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final authApiModule = _$AuthApiModule();
    gh.factory<_i660.CommerceMapper>(() => const _i660.CommerceMapper());
    gh.lazySingleton<_i228.CatalogLocalDataSource>(
        () => _i624.CatalogLocalDataSourceImpl());
    gh.lazySingleton<_i299.AuthApiService>(
        () => authApiModule.authApiService(gh<_i361.Dio>()));
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
        () => _i123.AuthRemoteDataSourceImpl(
              gh<_i299.AuthApiService>(),
              gh<_i666.SecureStorageService>(),
            ));
    gh.lazySingleton<_i204.CatalogRemoteDataSource>(
        () => _i790.CatalogRemoteDataSourceImpl());
    gh.factory<_i896.CatalogRepository>(() => _i973.CatalogRepositoryImpl(
          gh<_i228.CatalogLocalDataSource>(),
          gh<_i660.CommerceMapper>(),
          gh<_i204.CatalogRemoteDataSource>(),
        ));
    gh.lazySingleton<_i282.GetAllProductsUseCase>(
        () => _i282.GetAllProductsUseCase(gh<_i896.CatalogRepository>()));
    gh.lazySingleton<_i498.GetBestSellersUseCase>(
        () => _i498.GetBestSellersUseCase(gh<_i896.CatalogRepository>()));
    gh.lazySingleton<_i148.GetCategoriesUseCase>(
        () => _i148.GetCategoriesUseCase(gh<_i896.CatalogRepository>()));
    gh.lazySingleton<_i448.GetOccasionsUseCase>(
        () => _i448.GetOccasionsUseCase(gh<_i896.CatalogRepository>()));
    gh.lazySingleton<_i44.GetProductByIdUseCase>(
        () => _i44.GetProductByIdUseCase(gh<_i896.CatalogRepository>()));
    gh.lazySingleton<_i946.GetProductsByCategoryUseCase>(() =>
        _i946.GetProductsByCategoryUseCase(gh<_i896.CatalogRepository>()));
    gh.lazySingleton<_i874.GetProductsByOccasionUseCase>(() =>
        _i874.GetProductsByOccasionUseCase(gh<_i896.CatalogRepository>()));
    gh.lazySingleton<_i711.SearchProductsUseCase>(
        () => _i711.SearchProductsUseCase(gh<_i896.CatalogRepository>()));
    gh.lazySingleton<_i787.AuthRepository>(
        () => _i153.AuthRepositoryImpl(gh<_i107.AuthRemoteDataSource>()));
    gh.factory<_i680.BestSellerCubit>(
        () => _i680.BestSellerCubit(gh<_i498.GetBestSellersUseCase>()));
    gh.factory<_i525.ProductDetailsCubit>(
        () => _i525.ProductDetailsCubit(gh<_i44.GetProductByIdUseCase>()));
    gh.factory<_i20.HomeCubit>(() => _i20.HomeCubit(
          gh<_i148.GetCategoriesUseCase>(),
          gh<_i498.GetBestSellersUseCase>(),
          gh<_i448.GetOccasionsUseCase>(),
        ));
    gh.factory<_i446.CategoriesCubit>(() => _i446.CategoriesCubit(
          gh<_i946.GetProductsByCategoryUseCase>(),
          gh<_i148.GetCategoriesUseCase>(),
        ));
    gh.lazySingleton<_i69.ContinueAsGuestUseCase>(
        () => _i69.ContinueAsGuestUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i560.ForgotPasswordUseCase>(
        () => _i560.ForgotPasswordUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i188.LoginUseCase>(
        () => _i188.LoginUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i474.ResetPasswordUseCase>(
        () => _i474.ResetPasswordUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i860.SignUpUseCase>(
        () => _i860.SignUpUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i503.VerifyOtpUseCase>(
        () => _i503.VerifyOtpUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i117.AuthCubit>(() => _i117.AuthCubit(
          gh<_i188.LoginUseCase>(),
          gh<_i69.ContinueAsGuestUseCase>(),
          gh<_i860.SignUpUseCase>(),
          gh<_i560.ForgotPasswordUseCase>(),
          gh<_i503.VerifyOtpUseCase>(),
          gh<_i474.ResetPasswordUseCase>(),
        ));
    return this;
  }
}

class _$AuthApiModule extends _i433.AuthApiModule {}
