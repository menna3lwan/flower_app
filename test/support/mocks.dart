import 'package:mockito/mockito.dart';

import 'package:customer_app/core/domain/entities/product_entity.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/core/usecase/usecase.dart';
import 'package:customer_app/features/auth/api/auth_api_service.dart';
import 'package:customer_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:customer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:customer_app/features/commerce/data/api/home_api_service.dart';
import 'package:customer_app/features/commerce/data/data_sources/remote/home_remote_data_source.dart';
import 'package:customer_app/features/commerce/data/models/home_section_dto.dart';
import 'package:customer_app/features/commerce/domain/entities/category_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_content_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/occasion_entity.dart';
import 'package:customer_app/features/commerce/domain/repositories/home_repository.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_best_sellers_use_case.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_categories_use_case.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_home_sections_use_case.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_occasions_use_case.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_products_by_category_use_case.dart';
import 'package:customer_app/features/commerce/domain/use_cases/get_products_by_occasion_use_case.dart';
import 'package:customer_app/features/commerce/domain/use_cases/load_home_use_case.dart';

class MockAuthApiService extends Mock implements AuthApiService {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockHomeApiService extends Mock implements HomeApiService {
  @override
  Future<Map<String, dynamic>> getHomeSections() => super.noSuchMethod(
        Invocation.method(#getHomeSections, []),
        returnValue: Future<Map<String, dynamic>>.value(
          const <String, dynamic>{},
        ),
      ) as Future<Map<String, dynamic>>;
}

class MockHomeRemoteDataSource extends Mock implements HomeRemoteDataSource {
  @override
  Future<List<HomeSectionDto>> getHomeSections() => super.noSuchMethod(
        Invocation.method(#getHomeSections, []),
        returnValue: Future<List<HomeSectionDto>>.value(
          const <HomeSectionDto>[],
        ),
      ) as Future<List<HomeSectionDto>>;
}

class MockHomeRepository extends Mock implements HomeRepository {
  @override
  Future<Result<List<HomeSectionEntity>>> getHomeSections() =>
      super.noSuchMethod(
        Invocation.method(#getHomeSections, []),
        returnValue: Future<Result<List<HomeSectionEntity>>>.value(
          const Result.success(<HomeSectionEntity>[]),
        ),
      ) as Future<Result<List<HomeSectionEntity>>>;
}

class MockGetHomeSectionsUseCase extends Mock
    implements GetHomeSectionsUseCase {
  @override
  Future<Result<List<HomeSectionEntity>>> call(NoParams params) =>
      super.noSuchMethod(
        Invocation.method(#call, [params]),
        returnValue: Future<Result<List<HomeSectionEntity>>>.value(
          const Result.success(<HomeSectionEntity>[]),
        ),
      ) as Future<Result<List<HomeSectionEntity>>>;
}

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {
  @override
  Future<Result<List<CategoryEntity>>> call(NoParams params) =>
      super.noSuchMethod(
        Invocation.method(#call, [params]),
        returnValue: Future<Result<List<CategoryEntity>>>.value(
          const Result.success(<CategoryEntity>[]),
        ),
      ) as Future<Result<List<CategoryEntity>>>;
}

class MockGetOccasionsUseCase extends Mock implements GetOccasionsUseCase {
  @override
  Future<Result<List<OccasionEntity>>> call(NoParams params) =>
      super.noSuchMethod(
        Invocation.method(#call, [params]),
        returnValue: Future<Result<List<OccasionEntity>>>.value(
          const Result.success(<OccasionEntity>[]),
        ),
      ) as Future<Result<List<OccasionEntity>>>;
}

class MockGetBestSellersUseCase extends Mock implements GetBestSellersUseCase {
  @override
  Future<Result<List<ProductEntity>>> call(NoParams params) =>
      super.noSuchMethod(
        Invocation.method(#call, [params]),
        returnValue: Future<Result<List<ProductEntity>>>.value(
          const Result.success(<ProductEntity>[]),
        ),
      ) as Future<Result<List<ProductEntity>>>;
}

class MockGetProductsByOccasionUseCase extends Mock
    implements GetProductsByOccasionUseCase {
  // Param widened to Object? so Mockito's `any` matcher (typed as Null) still type-checks.
  @override
  Future<Result<List<ProductEntity>>> call(Object? occasionId) =>
      super.noSuchMethod(
        Invocation.method(#call, [occasionId]),
        returnValue: Future<Result<List<ProductEntity>>>.value(
          const Result.success(<ProductEntity>[]),
        ),
      ) as Future<Result<List<ProductEntity>>>;
}

class MockGetProductsByCategoryUseCase extends Mock
    implements GetProductsByCategoryUseCase {
  @override
  Future<Result<List<ProductEntity>>> call(Object? categoryId) =>
      super.noSuchMethod(
        Invocation.method(#call, [categoryId]),
        returnValue: Future<Result<List<ProductEntity>>>.value(
          const Result.success(<ProductEntity>[]),
        ),
      ) as Future<Result<List<ProductEntity>>>;
}

class MockLoadHomeUseCase extends Mock implements LoadHomeUseCase {
  @override
  Future<Result<List<HomeSectionContentEntity>>> call(NoParams params) =>
      super.noSuchMethod(
        Invocation.method(#call, [params]),
        returnValue: Future<Result<List<HomeSectionContentEntity>>>.value(
          const Result.success(<HomeSectionContentEntity>[]),
        ),
      ) as Future<Result<List<HomeSectionContentEntity>>>;
}
