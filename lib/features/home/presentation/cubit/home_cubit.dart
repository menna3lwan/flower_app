import 'package:customer_app/core/base/base_cubit.dart';
import '../../../catalog/domain/repositories/catalog_repository.dart';
import './home_state.dart';

/// Loads everything the Home screen renders (categories row, best-seller
/// row, occasion row) in parallel and exposes it as a single
/// [HomeLoaded] snapshot. Modeled as one Cubit rather than three
/// independent ones because the Home screen is one cohesive view — the
/// user does not perceive "categories" and "best sellers" as separately
/// loadable regions.
class HomeCubit extends BaseCubit<HomeState> {
  HomeCubit(this._catalogRepository) : super(const HomeLoading());

  final CatalogRepository _catalogRepository;

  Future<void> loadHome() async {
    safeEmit(const HomeLoading());

    final categoriesResult = await _catalogRepository.getCategories();
    final bestSellersResult = await _catalogRepository.getBestSellers();
    final occasionsResult = await _catalogRepository.getOccasions();

    if (categoriesResult.isFailure) {
      safeEmit(categoriesResult.fold((f) => HomeError(f.message), (_) => const HomeError('')));
      return;
    }
    if (bestSellersResult.isFailure) {
      safeEmit(bestSellersResult.fold((f) => HomeError(f.message), (_) => const HomeError('')));
      return;
    }
    if (occasionsResult.isFailure) {
      safeEmit(occasionsResult.fold((f) => HomeError(f.message), (_) => const HomeError('')));
      return;
    }

    safeEmit(
      HomeLoaded(
        categories: categoriesResult.fold((_) => const [], (data) => data),
        bestSellers: bestSellersResult.fold((_) => const [], (data) => data.take(6).toList()),
        occasions: occasionsResult.fold((_) => const [], (data) => data),
      ),
    );
  }
}
