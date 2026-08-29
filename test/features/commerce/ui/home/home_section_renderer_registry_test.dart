import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/features/commerce/domain/entities/home_section_content_entity.dart';
import 'package:customer_app/features/commerce/ui/home/registry/home_section_renderer_registry.dart';
import 'package:customer_app/features/commerce/ui/home/widgets/sections/best_seller_section_renderer.dart';
import 'package:customer_app/features/commerce/ui/home/widgets/sections/categories_section_renderer.dart';
import 'package:customer_app/features/commerce/ui/home/widgets/sections/occasions_section_renderer.dart';
import 'package:customer_app/features/commerce/ui/home/widgets/sections/products_carousel_section_renderer.dart';

import '../../../../support/localization_harness.dart';

const _categories = CategoriesSectionContent(
  id: '1',
  order: 0,
  status: HomeSectionLoadStatus.empty,
);
const _occasions = OccasionsSectionContent(
  id: '2',
  order: 1,
  status: HomeSectionLoadStatus.empty,
);
const _bestSeller = BestSellerSectionContent(
  id: '3',
  order: 2,
  status: HomeSectionLoadStatus.empty,
);
const _carousel = ProductsCarouselSectionContent(
  id: '4',
  order: 3,
  status: HomeSectionLoadStatus.empty,
);
const _unsupported = UnsupportedSectionContent(id: '5', order: 4);

void main() {
  setUpAll(initializeTestLocalization);

  group('renderer.supports — each renderer matches only its own section type', () {
    test('CategoriesSectionRenderer', () {
      const renderer = CategoriesSectionRenderer();
      expect(renderer.supports(_categories), isTrue);
      expect(renderer.supports(_bestSeller), isFalse);
      expect(renderer.supports(_unsupported), isFalse);
    });

    test('OccasionsSectionRenderer', () {
      const renderer = OccasionsSectionRenderer();
      expect(renderer.supports(_occasions), isTrue);
      expect(renderer.supports(_categories), isFalse);
    });

    test('BestSellerSectionRenderer', () {
      const renderer = BestSellerSectionRenderer();
      expect(renderer.supports(_bestSeller), isTrue);
      expect(renderer.supports(_carousel), isFalse);
    });

    test('ProductsCarouselSectionRenderer', () {
      const renderer = ProductsCarouselSectionRenderer();
      expect(renderer.supports(_carousel), isTrue);
      expect(renderer.supports(_bestSeller), isFalse);
    });
  });

  group('HomeSectionRendererRegistry.build', () {
    late HomeSectionRendererRegistry registry;

    setUp(() {
      registry = HomeSectionRendererRegistry();
    });

    Future<BuildContext> pumpAndGetContext(WidgetTester tester) async {
      await pumpLocalized(tester, localizedApp(home: const Scaffold()));
      return tester.element(find.byType(Scaffold));
    }

    testWidgets('routes a known section type to its matching renderer output',
        (tester) async {
      final context = await pumpAndGetContext(tester);

      final widget = registry.build(context, _categories);

      expect(widget, isNot(isA<SizedBox>()));
    });

    testWidgets('an unsupported section type renders nothing (no crash)',
        (tester) async {
      final context = await pumpAndGetContext(tester);

      final widget = registry.build(context, _unsupported);

      expect(widget, isA<SizedBox>());
      expect((widget as SizedBox).width, 0.0);
      expect(widget.height, 0.0);
      expect(widget.child, isNull);
    });
  });
}
