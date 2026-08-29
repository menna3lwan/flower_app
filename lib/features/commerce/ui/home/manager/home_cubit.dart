import 'package:injectable/injectable.dart';

import 'package:customer_app/core/base/base_cubit.dart';
import 'package:customer_app/core/error/failures.dart';
import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/core/usecase/usecase.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_content_entity.dart';
import 'package:customer_app/features/commerce/domain/use_cases/load_home_use_case.dart';
import 'home_state.dart';

/// State management only — every fetch/parsing/orchestration decision lives in [LoadHomeUseCase].
@injectable
class HomeCubit extends BaseCubit<HomeState> {
  HomeCubit(this._loadHome) : super(const HomeInitial());

  final LoadHomeUseCase _loadHome;

  Future<void> loadHome() async {
    safeEmit(const HomeLoading());
    final result = await _loadHome(const NoParams());
    safeEmit(_toState(result));
  }

  /// Pull-to-refresh: keeps the currently visible sections on failure instead of replacing them with a full-screen error.
  Future<void> refreshHome() async {
    final current = state;
    safeEmit(
      current is HomeLoaded
          ? current.copyWith(isRefreshing: true, clearRefreshFailure: true)
          : const HomeLoading(),
    );

    final result = await _loadHome(const NoParams());
    final refreshingState = state;
    if (refreshingState is HomeLoaded && result.isFailure) {
      safeEmit(
        refreshingState.copyWith(
          isRefreshing: false,
          refreshFailure: result.fold<Failure?>((failure) => failure, (_) => null),
        ),
      );
      return;
    }
    safeEmit(_toState(result));
  }

  /// Clears the one-shot refresh failure once the view has shown it.
  void consumeRefreshFailure() {
    final current = state;
    if (current is HomeLoaded && current.refreshFailure != null) {
      safeEmit(current.copyWith(clearRefreshFailure: true));
    }
  }

  HomeState _toState(Result<List<HomeSectionContentEntity>> result) {
    return switch (result) {
      ResultFailure(:final failure) => HomeError(failure),
      Success(:final data) =>
        data.isEmpty ? const HomeEmpty() : HomeLoaded(sections: data),
    };
  }
}
