import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import 'package:customer_app/features/commerce/domain/entities/home_section_content_entity.dart';
import '../widgets/sections/best_seller_section_renderer.dart';
import '../widgets/sections/categories_section_renderer.dart';
import '../widgets/sections/occasions_section_renderer.dart';
import '../widgets/sections/products_carousel_section_renderer.dart';
import 'home_section_renderer.dart';

/// The one place that maps a server section to its Flutter widget — adding a section type means adding one renderer here, not touching the view.
@lazySingleton
class HomeSectionRendererRegistry {
  HomeSectionRendererRegistry()
      : _renderers = const [
          CategoriesSectionRenderer(),
          OccasionsSectionRenderer(),
          BestSellerSectionRenderer(),
          ProductsCarouselSectionRenderer(),
        ];

  final List<HomeSectionRenderer> _renderers;

  /// Falls back to an empty widget for any section no registered renderer supports (unsupported/unknown types).
  Widget build(BuildContext context, HomeSectionContentEntity section) {
    for (final renderer in _renderers) {
      if (renderer.supports(section)) return renderer.build(context, section);
    }
    return const SizedBox.shrink();
  }
}
