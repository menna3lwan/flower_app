import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/base/operation_state.dart';
import '../../../../../../core/base/pagination_params.dart';
import '../../../../../../core/base/pagination_state.dart';
import '../../../../../../core/result/result.dart';
import '../../../../../../core/usecase/usecase.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../../domain/entities/products_data_entity.dart';
import '../../../../domain/use_cases/get_categories_use_case.dart';
import '../../../../domain/use_cases/get_products_by_category_use_case.dart';
import 'categories_intent.dart';
import 'categories_state.dart';

@injectable
class CategoriesCubit extends Cubit<CategoriesState> {
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoriesCubit(
    this._getProductsByCategoryUseCase,
    this._getCategoriesUseCase,
  ) : super(
        const CategoriesState(
          productsByCategoryIdState: PaginationState(),
          categoriesState: OperationState(),
        ),
      );

  Future<void> doIntent(CategoriesIntent intent) async {
    switch (intent) {
      case GetProductsByCategoryIdIntent():
        await _getProductsByCategoriesId(intent);
        break;
      case LoadMoreProductsByCategoryIdIntent():
        await _loadMoreProductsByCategoryId(intent);
        break;
      case GetCategoriesIntent():
        await _getCategories(intent);
        break;
    }
  }

  Future<void> _getCategories(GetCategoriesIntent intent) async {
    emit(state.copyWith(categoriesState: state.categoriesState.loading()));
    debugPrint('the current state: ${state.categoriesState.status}');

    final response = await _getCategoriesUseCase(NoParams());

    switch (response) {
      case Success<List<CategoryEntity>>():
        emit(
          state.copyWith(
            categoriesState: state.categoriesState.success(response.data),
          ),
        );
        debugPrint('the current state: ${state.categoriesState.status}');
        debugPrint('the current product: ${state.categoriesState.data}');
        break;
      case ResultFailure<List<CategoryEntity>>():
        emit(
          state.copyWith(
            categoriesState: state.categoriesState.failed(response.failure),
          ),
        );
        debugPrint('the current state: ${state.categoriesState.status}');
        break;
    }
  }

  Future<void> _getProductsByCategoriesId(
    GetProductsByCategoryIdIntent intent,
  ) async {
    emit(
      state.copyWith(
        productsByCategoryIdState: state.productsByCategoryIdState.loading(),
      ),
    );

    final response = await _getProductsByCategoryUseCase(
      ParamsWithPagination(
        pagination: const PaginationParams(page: 1),
        param: intent.categoryId,
      ),
    );

    switch (response) {
      case Success<ProductsDataEntity>():
        emit(
          state.copyWith(
            productsByCategoryIdState: state.productsByCategoryIdState.success(
              response.data.items ?? [],
              hasReachedMax: !(response.data.pagination?.hasNextPage ?? false),
            ),
          ),
        );
        break;
      case ResultFailure<ProductsDataEntity>():
        emit(
          state.copyWith(
            productsByCategoryIdState: state.productsByCategoryIdState.failed(
              response.failure,
            ),
          ),
        );
        break;
    }
  }

  Future<void> _loadMoreProductsByCategoryId(
    LoadMoreProductsByCategoryIdIntent intent,
  ) async {
    if (state.productsByCategoryIdState.hasReachedMax ||
        state.productsByCategoryIdState.isFetchingMore ||
        state.productsByCategoryIdState.isLoading) {
      return;
    }

    emit(
      state.copyWith(
        productsByCategoryIdState: state.productsByCategoryIdState
            .fetchingMore(),
      ),
    );

    final response = await _getProductsByCategoryUseCase(
      ParamsWithPagination(
        pagination: PaginationParams(
          page: state.productsByCategoryIdState.currentPage + 1,
        ),
        param: intent.categoryId,
      ),
    );

    switch (response) {
      case Success<ProductsDataEntity>():
        emit(
          state.copyWith(
            productsByCategoryIdState: state.productsByCategoryIdState
                .fetchMoreSuccess(
                  response.data.items ?? [],
                  hasReachedMax:
                      !(response.data.pagination?.hasNextPage ?? false),
                ),
          ),
        );
        break;
      case ResultFailure<ProductsDataEntity>():
        emit(
          state.copyWith(
            productsByCategoryIdState: state.productsByCategoryIdState
                .fetchMoreFailed(response.failure),
          ),
        );
        break;
    }
  }
}
