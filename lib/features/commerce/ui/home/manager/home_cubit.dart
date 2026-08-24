import 'package:injectable/injectable.dart';

import 'package:customer_app/core/base/base_cubit.dart';
import 'package:customer_app/core/usecase/usecase.dart';
import '../../../domain/use_cases/get_best_sellers_use_case.dart';
import '../../../domain/use_cases/get_categories_use_case.dart';
import '../../../domain/use_cases/get_occasions_use_case.dart';
import 'home_state.dart';

/// Loads Home's three sections as one [HomeLoaded] snapshot via three single-purpose use cases, never `CatalogRepository` directly.
@injectable
class HomeCubit extends BaseCubit<HomeState> {
  HomeCubit(
    this._getCategories,
    this._getBestSellers,
    this._getOccasions,
  ) : super(const HomeLoading());

  final GetCategoriesUseCase _getCategories;
  final GetBestSellersUseCase _getBestSellers;
  final GetOccasionsUseCase _getOccasions;

  Future<void> loadHome() async {
    safeEmit(const HomeLoading());

    final categoriesResult = await _getCategories(const NoParams());
    final bestSellersResult = await _getBestSellers(const NoParams());
    final occasionsResult = await _getOccasions(const NoParams());

    if (categoriesResult.isFailure) {
      safeEmit(categoriesResult.fold(
          (f) => HomeError(f.message), (_) => const HomeError('')));
      return;
    }
    if (bestSellersResult.isFailure) {
      safeEmit(bestSellersResult.fold(
          (f) => HomeError(f.message), (_) => const HomeError('')));
      return;
    }
    if (occasionsResult.isFailure) {
      safeEmit(occasionsResult.fold(
          (f) => HomeError(f.message), (_) => const HomeError('')));
      return;
    }

    safeEmit(
      HomeLoaded(
        categories: categoriesResult.fold((_) => const [], (data) => data),
        bestSellers: bestSellersResult.fold(
            (_) => const [], (data) => data.take(6).toList()),
        occasions: occasionsResult.fold((_) => const [], (data) => data),
      ),
    );
  }
}
