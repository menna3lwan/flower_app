import 'package:equatable/equatable.dart';
import '../error/failures.dart';
import 'operation_state.dart';

class PaginationState<T> extends Equatable {
  const PaginationState({
    this.status = OperationStatus.idle,
    this.items = const [],
    this.error,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
    this.fetchMoreError,
    this.currentPage = 1,
  });

  final OperationStatus status;
  final List<T> items;
  final Failure? error;
  final bool hasReachedMax;
  final bool isFetchingMore;
  final Failure? fetchMoreError;
  final int currentPage;

  bool get isIdle => status == OperationStatus.idle;
  bool get isLoading => status == OperationStatus.loading;
  bool get isSuccess => status == OperationStatus.success;
  bool get isFailure => status == OperationStatus.failure;

  PaginationState<T> loading() => copyWith(
        status: OperationStatus.loading,
        error: null,
      );

  PaginationState<T> success(List<T> newItems, {required bool hasReachedMax}) => copyWith(
        status: OperationStatus.success,
        items: newItems,
        hasReachedMax: hasReachedMax,
        isFetchingMore: false,
        fetchMoreError: null,
        error: null,
      );

  PaginationState<T> failed(Failure error) => copyWith(
        status: OperationStatus.failure,
        error: error,
      );
      
  PaginationState<T> fetchingMore() => copyWith(
        isFetchingMore: true,
        fetchMoreError: null,
      );

  PaginationState<T> fetchMoreSuccess(List<T> moreItems, {required bool hasReachedMax}) => copyWith(
        items: [...items, ...moreItems],
        isFetchingMore: false,
        hasReachedMax: hasReachedMax,
        currentPage: currentPage + 1,
        fetchMoreError: null,
      );

  PaginationState<T> fetchMoreFailed(Failure error) => copyWith(
        isFetchingMore: false,
        fetchMoreError: error,
      );

  PaginationState<T> copyWith({
    OperationStatus? status,
    List<T>? items,
    Failure? error,
    bool? hasReachedMax,
    bool? isFetchingMore,
    Failure? fetchMoreError,
    int? currentPage,
  }) {
    return PaginationState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error ?? (status == OperationStatus.loading || status == OperationStatus.success ? null : this.error),
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      fetchMoreError: fetchMoreError ?? (isFetchingMore == true || status == OperationStatus.loading ? null : this.fetchMoreError),
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        error,
        hasReachedMax,
        isFetchingMore,
        fetchMoreError,
        currentPage,
      ];
}
