import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/core/routing/customer_routes.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_content_entity.dart';
import 'package:customer_app/features/commerce/ui/home/widgets/sections/products_carousel_section_renderer.dart';

void main() {
  group('ProductsCarouselSectionRenderer view-all navigation', () {
    test('occasion-filtered carousel routes to occasion listing with occasionId',
        () {
      const section = ProductsCarouselSectionContent(
        id: 'c1',
        order: 0,
        status: HomeSectionLoadStatus.success,
        occasionId: 'occ-wedding',
      );

      expect(
        ProductsCarouselSectionRenderer.viewAllRouteFor(section),
        CustomerRoutes.occasionListing,
      );
      expect(
        ProductsCarouselSectionRenderer.viewAllArgumentsFor(section),
        'occ-wedding',
      );
    });

    test('category-filtered carousel routes to categories with categoryId', () {
      const section = ProductsCarouselSectionContent(
        id: 'c2',
        order: 1,
        status: HomeSectionLoadStatus.success,
        categoryId: 'cat-flowers',
      );

      expect(
        ProductsCarouselSectionRenderer.viewAllRouteFor(section),
        CustomerRoutes.categories,
      );
      expect(
        ProductsCarouselSectionRenderer.viewAllArgumentsFor(section),
        'cat-flowers',
      );
    });
  });
}
