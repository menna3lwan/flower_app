import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/routing/customer_routes.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';
import 'package:customer_app/common/widgets/app_section_header.dart';
import 'package:customer_app/common/widgets/media/app_image_placeholder.dart';
import 'package:customer_app/features/commerce/domain/entities/home_section_content_entity.dart';
import 'package:customer_app/features/commerce/domain/entities/occasion_entity.dart';
import '../../registry/home_section_renderer.dart';
import '../home_scroll_physics.dart';
import 'home_section_body.dart';

class OccasionsSectionRenderer implements HomeSectionRenderer {
  const OccasionsSectionRenderer();

  @override
  bool supports(HomeSectionContentEntity section) =>
      section is OccasionsSectionContent;

  @override
  Widget build(BuildContext context, HomeSectionContentEntity section) {
    final occasions = section as OccasionsSectionContent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: occasions.title ?? AppStrings.occasion,
          onViewAllTap: () => Get.toNamed(CustomerRoutes.occasionListing),
          viewAllLabel: AppStrings.viewAll,
          titleStyle: AppTextStyles.sectionTitle,
          viewAllStyle: AppTextStyles.sectionViewAll,
        ),
        const SizedBox(height: AppDimens.space16),
        homeSectionBody(
          status: occasions.status,
          success: () => HomeHorizontalScroller(
            height: AppDimens.occasionCardHeight,
            itemCount: occasions.occasions.length,
            itemBuilder: (context, index) {
              final occasion = occasions.occasions[index];
              return _OccasionCard(
                key: ValueKey(occasion.id),
                occasion: occasion,
                width: AppDimens.homeCardWidth,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OccasionCard extends StatelessWidget {
  const _OccasionCard({
    required this.occasion,
    required this.width,
    super.key,
  });

  final OccasionEntity occasion;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        CustomerRoutes.occasionListing,
        arguments: occasion.id,
      ),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AspectRatio(
              aspectRatio: AppDimens.homeCardAspectRatio,
              child: AppImagePlaceholder(borderRadius: BorderRadius.zero),
            ),
            const SizedBox(height: AppDimens.space8),
            Text(
              occasion.name,
              style: AppTextStyles.homeOccasionLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
