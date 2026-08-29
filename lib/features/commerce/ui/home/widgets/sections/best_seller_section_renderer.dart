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

class BestSellerSectionRenderer implements HomeSectionRenderer {
  const BestSellerSectionRenderer();

  @override
  bool supports(HomeSectionContentEntity section) =>
      section is BestSellerSectionContent;

  @override
  Widget build(BuildContext context, HomeSectionContentEntity section) {
    final bestSeller = section as BestSellerSectionContent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: bestSeller.title ?? AppStrings.bestSeller,
          onViewAllTap: () => Get.toNamed(CustomerRoutes.bestSellerListing),
          viewAllLabel: AppStrings.viewAll,
          titleStyle: AppTextStyles.sectionTitle,
          viewAllStyle: AppTextStyles.sectionViewAll,
        ),
        const SizedBox(height: AppDimens.space16),
        homeSectionBody(
          status: bestSeller.status,
          success: () => HomeHorizontalScroller(
            height: AppDimens.productPreviewCardHeight,
            itemCount: bestSeller.products.length,
            itemBuilder: (context, index) {
              final product = bestSeller.products[index];
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
}
