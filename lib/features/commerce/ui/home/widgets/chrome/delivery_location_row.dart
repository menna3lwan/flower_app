import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:customer_app/common/extensions/context_extensions.dart';
import 'package:customer_app/core/constants/app_assets.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

/// Figma-verified "Deliver to <address>" row. No saved-address feature exists yet, so the address
/// is a static placeholder and tapping surfaces "coming soon" rather than a dead-end or a crash.
class DeliveryLocationRow extends StatelessWidget {
  const DeliveryLocationRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
      child: GestureDetector(
        onTap: () => context.showInfoSnackBar(AppStrings.comingSoon),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.deliveryLocationIcon,
              width: AppDimens.chromeIconSize,
              height: AppDimens.chromeIconSize,
            ),
            const SizedBox(width: AppDimens.space8),
            Text.rich(
              TextSpan(
                style: AppTextStyles.labelMedium
                    .copyWith(color: AppColors.textMuted),
                children: [
                  TextSpan(text: '${AppStrings.deliverTo} '),
                  TextSpan(
                    text: AppStrings.homeDeliveryAddressPlaceholder,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: AppDimens.space8),
            Transform.rotate(
              angle: -1.5708,
              child: SvgPicture.asset(
                AppAssets.chevronIcon,
                width: AppDimens.iconSizeSmall,
                height: AppDimens.iconSizeSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
