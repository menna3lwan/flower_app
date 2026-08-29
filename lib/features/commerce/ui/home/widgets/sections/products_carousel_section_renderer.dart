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
import 'home_section_body.dart';

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
          onViewAllTap: () => Get.toNamed(
            viewAllRouteFor(carousel),
            arguments: viewAllArgumentsFor(carousel),
          ),
          viewAllLabel: AppStrings.viewAll,
          titleStyle: AppTextStyles.sectionTitle,
          viewAllStyle: AppTextStyles.sectionViewAll,
        ),
        const SizedBox(height: AppDimens.space16),
        homeSectionBody(
          status: carousel.status,
          success: () => HomeHorizontalScroller(
            height: AppDimens.productPreviewCardHeight,
            itemCount: carousel.products.length,
            itemBuilder: (context, index) {
              final product = carousel.products[index];
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
          ),
        ),
      ],
    );
  }

  @visibleForTesting
  static String viewAllRouteFor(ProductsCarouselSectionContent section) {
    if (section.occasionId != null) return CustomerRoutes.occasionListing;
    return CustomerRoutes.categories;
  }

  @visibleForTesting
  static String? viewAllArgumentsFor(ProductsCarouselSectionContent section) =>
      section.occasionId ?? section.categoryId;
}
