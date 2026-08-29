import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/routing/customer_routes.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';
import 'package:customer_app/common/widgets/app_section_header.dart';
import 'package:customer_app/features/commerce/domain/entities/category_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_content_entity.dart';
import '../../registry/home_section_renderer.dart';
import '../home_scroll_physics.dart';
import 'category_icon.dart';
import 'home_section_body.dart';

class CategoriesSectionRenderer implements HomeSectionRenderer {
  const CategoriesSectionRenderer();

  @override
  bool supports(HomeSectionContentEntity section) =>
      section is CategoriesSectionContent;

  @override
  Widget build(BuildContext context, HomeSectionContentEntity section) {
    final categories = section as CategoriesSectionContent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: categories.title ?? AppStrings.categories,
          onViewAllTap: () => Get.toNamed(CustomerRoutes.categories),
          viewAllLabel: AppStrings.viewAll,
          titleStyle: AppTextStyles.sectionTitle,
          viewAllStyle: AppTextStyles.sectionViewAll,
        ),
        const SizedBox(height: AppDimens.space16),
        homeSectionBody(
          status: categories.status,
          success: () => HomeHorizontalScroller(
            height: AppDimens.categoryCardsRowHeight,
            itemCount: categories.categories.length,
            itemBuilder: (context, index) {
              final category = categories.categories[index];
              return _CategoryChip(
                key: ValueKey(category.id),
                category: category,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category, super.key});

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        CustomerRoutes.categories,
        arguments: category.id,
      ),
      child: SizedBox(
        width: AppDimens.categoryChipWidth,
        child: Column(
          children: [
            Container(
              width: AppDimens.categoryChipWidth,
              height: AppDimens.categoryIconSize,
              decoration: BoxDecoration(
                color: AppColors.categoryChipBackground,
                borderRadius: BorderRadius.circular(AppDimens.radiusExtraLarge),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                categoryIconAssetFor(category.iconName),
                width: AppDimens.iconSize,
                height: AppDimens.iconSize,
                colorFilter: const ColorFilter.mode(
                  AppColors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: AppDimens.space8),
            Text(
              category.name,
              style: AppTextStyles.homeChipLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
