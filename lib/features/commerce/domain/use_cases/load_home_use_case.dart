import 'package:injectable/injectable.dart';

import 'package:customer_app/core/result/result.dart';
import 'package:customer_app/core/usecase/usecase.dart';
import '../entities/home_section_content_entity.dart';
import '../entities/home_section_entity.dart';
import '../entities/home_section_type.dart';
import 'get_best_sellers_use_case.dart';
import 'get_categories_use_case.dart';
import 'get_home_sections_use_case.dart';
import 'get_occasions_use_case.dart';
import 'get_products_by_category_use_case.dart';
import 'get_products_by_occasion_use_case.dart';

/// Orchestrates the server-driven Home load: fetches the section layout, then hydrates each section via the matching Catalog use case, isolating failures per section.
@lazySingleton
class LoadHomeUseCase
    implements UseCase<List<HomeSectionContentEntity>, NoParams> {
  const LoadHomeUseCase(
    this._getHomeSections,
    this._getCategories,
    this._getOccasions,
    this._getBestSellers,
    this._getProductsByOccasion,
    this._getProductsByCategory,
  );

  final GetHomeSectionsUseCase _getHomeSections;
  final GetCategoriesUseCase _getCategories;
  final GetOccasionsUseCase _getOccasions;
  final GetBestSellersUseCase _getBestSellers;
  final GetProductsByOccasionUseCase _getProductsByOccasion;
  final GetProductsByCategoryUseCase _getProductsByCategory;

  @override
  Future<Result<List<HomeSectionContentEntity>>> call(NoParams params) async {
    final sectionsResult = await _getHomeSections(const NoParams());
    return switch (sectionsResult) {
      ResultFailure(:final failure) => Result.failure(failure),
      Success(:final data) => Result.success(await _hydrateVisible(data)),
    };
  }

  /// Hydrates every section, then drops unsupported ones — Home should never render a gap for a section type it can't handle.
  Future<List<HomeSectionContentEntity>> _hydrateVisible(
    List<HomeSectionEntity> sections,
  ) async {
    final hydrated = await Future.wait(sections.map(_hydrate));
    final visible = hydrated
        .where((section) => section.status != HomeSectionLoadStatus.unsupported)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return visible;
  }

  Future<HomeSectionContentEntity> _hydrate(HomeSectionEntity section) {
    return switch (section.type) {
      HomeSectionType.categories => _hydrateCategories(section),
      HomeSectionType.occasions => _hydrateOccasions(section),
      HomeSectionType.bestSeller => _hydrateBestSeller(section),
      HomeSectionType.productsCarousel => _hydrateProductsCarousel(section),
      HomeSectionType.unknown => Future.value(UnsupportedSectionContent(
          id: section.id,
          order: section.order,
          title: section.title,
        )),
    };
  }

  Future<HomeSectionContentEntity> _hydrateCategories(
    HomeSectionEntity section,
  ) async {
    final result = await _getCategories(const NoParams());
    return result.fold(
      (failure) => CategoriesSectionContent(
        id: section.id,
        order: section.order,
        title: section.title,
        status: HomeSectionLoadStatus.failed,
      ),
      (categories) => CategoriesSectionContent(
        id: section.id,
        order: section.order,
        title: section.title,
        status: categories.isEmpty
            ? HomeSectionLoadStatus.empty
            : HomeSectionLoadStatus.success,
        categories: categories,
      ),
    );
  }

  Future<HomeSectionContentEntity> _hydrateOccasions(
    HomeSectionEntity section,
  ) async {
    final result = await _getOccasions(const NoParams());
    return result.fold(
      (failure) => OccasionsSectionContent(
        id: section.id,
        order: section.order,
        title: section.title,
        status: HomeSectionLoadStatus.failed,
      ),
      (occasions) => OccasionsSectionContent(
        id: section.id,
        order: section.order,
        title: section.title,
        status: occasions.isEmpty
            ? HomeSectionLoadStatus.empty
            : HomeSectionLoadStatus.success,
        occasions: occasions,
      ),
    );
  }

  Future<HomeSectionContentEntity> _hydrateBestSeller(
    HomeSectionEntity section,
  ) async {
    final result = await _getBestSellers(const NoParams());
    return result.fold(
      (failure) => BestSellerSectionContent(
        id: section.id,
        order: section.order,
        title: section.title,
        status: HomeSectionLoadStatus.failed,
      ),
      (products) => BestSellerSectionContent(
        id: section.id,
        order: section.order,
        title: section.title,
        status: products.isEmpty
            ? HomeSectionLoadStatus.empty
            : HomeSectionLoadStatus.success,
        products: products,
      ),
    );
  }

  Future<HomeSectionContentEntity> _hydrateProductsCarousel(
    HomeSectionEntity section,
  ) async {
    final occasionId = section.occasionId;
    final categoryId = section.categoryId;

    if (occasionId == null && categoryId == null) {
      // Malformed per the backend contract (ProductsCarousel must set one filter) — fail this section only.
      return ProductsCarouselSectionContent(
        id: section.id,
        order: section.order,
        title: section.title,
        status: HomeSectionLoadStatus.failed,
      );
    }

    final result = occasionId != null
        ? await _getProductsByOccasion(occasionId)
        : await _getProductsByCategory(categoryId!);

    return result.fold(
      (failure) => ProductsCarouselSectionContent(
        id: section.id,
        order: section.order,
        title: section.title,
        status: HomeSectionLoadStatus.failed,
        occasionId: occasionId,
        categoryId: categoryId,
      ),
      (products) => ProductsCarouselSectionContent(
        id: section.id,
        order: section.order,
        title: section.title,
        status: products.isEmpty
            ? HomeSectionLoadStatus.empty
            : HomeSectionLoadStatus.success,
        products: products,
        occasionId: occasionId,
        categoryId: categoryId,
      ),
    );
  }
}
