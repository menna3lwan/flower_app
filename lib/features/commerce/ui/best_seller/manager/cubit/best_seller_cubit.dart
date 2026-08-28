import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../../core/base/pagination_state.dart';
import '../../../../../../core/base/pagination_params.dart';
import '../../../../../../core/result/result.dart';
import '../../../../domain/entities/products_data_entity.dart';
import '../../../../domain/use_cases/get_best_sellers_use_case.dart';
import 'best_seller_state.dart';
import 'best_selleter_intent.dart';

@injectable
class BestSellerCubit extends Cubit<BestSellerState> {
  final GetBestSellersUseCase _getBestSellersUseCase;

  BestSellerCubit(this._getBestSellersUseCase)
      : super(const BestSellerState(operationState: PaginationState()));

  Future<void> doIntent(BestSellerIntent intent) async {
    switch (intent) {
      case GetBestSellerIntent():
        await _getBestSeller(intent);
        break;
      case LoadMoreBestSellerIntent():
        await _loadMore(intent);
        break;
    }
  }

  Future<void> _getBestSeller(GetBestSellerIntent intent) async {
    emit(state.copyWith(operationState: state.operationState.loading()));
    
    final response = await _getBestSellersUseCase(const PaginationParams(page: 1));

    switch (response) {
      case Success<ProductsDataEntity>():
        emit(
          state.copyWith(
            operationState: state.operationState.success(
              response.data.items ?? [],
              hasReachedMax: !(response.data.pagination?.hasNextPage ?? false),
            ),
          ),
        );
        break;
      case ResultFailure<ProductsDataEntity>():
        emit(
          state.copyWith(
            operationState: state.operationState.failed(response.failure),
          ),
        );
        break;
    }
  }

  Future<void> _loadMore(LoadMoreBestSellerIntent intent) async {
    if (state.operationState.hasReachedMax || state.operationState.isFetchingMore || state.operationState.isLoading) {
      return;
    }

    emit(state.copyWith(operationState: state.operationState.fetchingMore()));
    
    final response = await _getBestSellersUseCase(PaginationParams(page: state.operationState.currentPage + 1));

    switch (response) {
      case Success<ProductsDataEntity>():
        emit(
          state.copyWith(
            operationState: state.operationState.fetchMoreSuccess(
              response.data.items ?? [],
              hasReachedMax: !(response.data.pagination?.hasNextPage ?? false),
            ),
          ),
        );
        break;
      case ResultFailure<ProductsDataEntity>():
        emit(
          state.copyWith(
            operationState: state.operationState.fetchMoreFailed(response.failure),
          ),
        );
        break;
    }
  }
}
