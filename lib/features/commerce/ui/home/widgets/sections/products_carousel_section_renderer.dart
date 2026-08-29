import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/routing/customer_routes.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';
import 'package:customer_app/common/widgets/app_section_header.dart';
import 'package:customer_app/common/widgets/product_card.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_content_entity.dart';
import '../../registry/home_section_renderer.dart';
import '../home_scroll_physics.dart';
import 'section_state_box.dart';

/// Renders a [ProductsCarouselSectionContent] — a generic, server-titled products row; the title is server content, already localized, so it's shown as-is.
class ProductsCarouselSectionRenderer implements HomeSectionRenderer {
  const ProductsCarouselSectionRenderer();

  @override
  bool supports(HomeSectionContentEntity section) =>
      section is ProductsCarouselSectionContent;

  @override
  Widget build(BuildContext context, HomeSectionContentEntity section) {
    final carousel = section as ProductsCarouselSectionContent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: carousel.title ?? AppStrings.products,
          onViewAllTap: () => Get.toNamed(_viewAllRoute(carousel)),
          viewAllLabel: AppStrings.viewAll,
          titleStyle: AppTextStyles.sectionTitle,
          viewAllStyle: AppTextStyles.sectionViewAll,
        ),
        const SizedBox(height: AppDimens.space16),
        _animatedContent(context, carousel),
      ],
    );
  }

  String _viewAllRoute(ProductsCarouselSectionContent section) {
    if (section.occasionId != null) return CustomerRoutes.occasionListing;
    return CustomerRoutes.categories;
  }

  Widget _animatedContent(
    BuildContext context,
    ProductsCarouselSectionContent section,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOut,
      child: KeyedSubtree(
        key: ValueKey(section.status),
        child: _content(context, section),
      ),
    );
  }

  Widget _content(BuildContext context, ProductsCarouselSectionContent section) {
    if (section.status == HomeSectionLoadStatus.failed) {
      return SectionStateBox.error(message: AppStrings.somethingWentWrong);
    }
    if (section.status == HomeSectionLoadStatus.empty) {
      return SectionStateBox.empty(message: AppStrings.homeSectionEmpty);
    }
    return HomeHorizontalScroller(
      height: AppDimens.productPreviewCardHeight,
      itemCount: section.products.length,
      itemBuilder: (context, index) {
        final product = section.products[index];
        return ProductCard(
          key: ValueKey(product.id),
          product: product,
          width: AppDimens.homeCardWidth,
          onTap: () => Get.toNamed(
            CustomerRoutes.productDetails,
            arguments: product.id,
          ),
        );
      },
    );
  }
}
