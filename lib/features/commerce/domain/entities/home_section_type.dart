/// Server-driven Home section types, mirroring the backend's `HomeSectionType` enum.
enum HomeSectionType { categories, occasions, bestSeller, productsCarousel, unknown }

/// Parses the backend's raw `type` string; any unrecognized value degrades to [HomeSectionType.unknown] instead of throwing.
extension HomeSectionTypeParsing on String {
  HomeSectionType toHomeSectionType() => switch (this) {
        'Categories' => HomeSectionType.categories,
        'Occasions' => HomeSectionType.occasions,
        'BestSeller' => HomeSectionType.bestSeller,
        'ProductsCarousel' => HomeSectionType.productsCarousel,
        _ => HomeSectionType.unknown,
      };
}
