import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/base/operation_state.dart';
import '../../../../../../core/base/pagination_params.dart';
import '../../../../../../core/base/pagination_state.dart';
import '../../../../../../core/result/result.dart';
import '../../../../../../core/usecase/usecase.dart';
import '../../../../domain/entities/occasion_entity.dart';
import '../../../../domain/entities/products_data_entity.dart';
import '../../../../domain/use_cases/get_occasions_use_case.dart';
import '../../../../domain/use_cases/get_products_by_occasion_use_case.dart';
import 'occasions_intent.dart';
import 'occasions_state.dart';

@injectable
class OccasionsCubit extends Cubit<OccasionsState> {
  final GetProductsByOccasionUseCase _getProductsByOccasionUseCase;
  final GetOccasionsUseCase _getOccasionsUseCase;

  OccasionsCubit(
    this._getProductsByOccasionUseCase,
    this._getOccasionsUseCase,
  ) : super(
        const OccasionsState(
          productsByOccasionIdState: PaginationState(),
          occasionsState: OperationState(),
        ),
      );

  Future<void> doIntent(OccasionsIntent intent) async {
    switch (intent) {
      case GetProductsByOccasionIdIntent():
        await _getProductsByOccasionId(intent);
        break;
      case LoadMoreProductsByOccasionIdIntent():
        await _loadMoreProductsByOccasionId(intent);
        break;
      case GetOccasionsIntent():
        await _getOccasions(intent);
        break;
    }
  }

  Future<void> _getOccasions(GetOccasionsIntent intent) async {
    emit(state.copyWith(occasionsState: state.occasionsState.loading()));
    debugPrint('the current state: ${state.occasionsState.status}');

    final response = await _getOccasionsUseCase(const NoParams());

    switch (response) {
      case Success<List<OccasionEntity>>():
        emit(
          state.copyWith(
            occasionsState: state.occasionsState.success(response.data),
          ),
        );
        debugPrint('the current state: ${state.occasionsState.status}');
        debugPrint('the current product: ${state.occasionsState.data}');
        break;
      case ResultFailure<List<OccasionEntity>>():
        emit(
          state.copyWith(
            occasionsState: state.occasionsState.failed(response.failure),
          ),
        );
        debugPrint('the current state: ${state.occasionsState.status}');
        break;
    }
  }

  Future<void> _getProductsByOccasionId(
    GetProductsByOccasionIdIntent intent,
  ) async {
    emit(
      state.copyWith(
        productsByOccasionIdState: state.productsByOccasionIdState.loading(),
      ),
    );

    final response = await _getProductsByOccasionUseCase(
      ParamsWithPagination(
        pagination: const PaginationParams(page: 1),
        param: intent.occasionId,
      ),
    );

    switch (response) {
      case Success<ProductsDataEntity>():
        emit(
          state.copyWith(
            productsByOccasionIdState: state.productsByOccasionIdState.success(
              response.data.items ?? [],
              hasReachedMax: !(response.data.pagination?.hasNextPage ?? false),
            ),
          ),
        );
        break;
      case ResultFailure<ProductsDataEntity>():
        emit(
          state.copyWith(
            productsByOccasionIdState: state.productsByOccasionIdState.failed(
              response.failure,
            ),
          ),
        );
        break;
    }
  }

  Future<void> _loadMoreProductsByOccasionId(
    LoadMoreProductsByOccasionIdIntent intent,
  ) async {
    if (state.productsByOccasionIdState.hasReachedMax ||
        state.productsByOccasionIdState.isFetchingMore ||
        state.productsByOccasionIdState.isLoading) {
      return;
    }

    emit(
      state.copyWith(
        productsByOccasionIdState: state.productsByOccasionIdState
            .fetchingMore(),
      ),
    );

    final response = await _getProductsByOccasionUseCase(
      ParamsWithPagination(
        pagination: PaginationParams(
          page: state.productsByOccasionIdState.currentPage + 1,
        ),
        param: intent.occasionId,
      ),
    );

    switch (response) {
      case Success<ProductsDataEntity>():
        emit(
          state.copyWith(
            productsByOccasionIdState: state.productsByOccasionIdState
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
            productsByOccasionIdState: state.productsByOccasionIdState
                .fetchMoreFailed(response.failure),
          ),
        );
        break;
    }
  }
}
