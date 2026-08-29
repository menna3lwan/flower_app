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

/// Renders a [BestSellerSectionContent] as Home's best-seller row — compact [ProductCard] (no add-to-cart), reusing [AppSectionHeader].
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
        _animatedContent(context, bestSeller),
      ],
    );
  }

  Widget _animatedContent(
    BuildContext context,
    BestSellerSectionContent section,
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

  Widget _content(BuildContext context, BestSellerSectionContent section) {
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
