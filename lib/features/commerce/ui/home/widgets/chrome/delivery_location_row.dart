import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:customer_app/common/extensions/context_extensions.dart';
import 'package:customer_app/core/constants/app_assets.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

/// "Deliver to <address>" row. No saved-address feature yet — tapping surfaces "coming soon".
class DeliveryLocationRow extends StatelessWidget {
  const DeliveryLocationRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.showInfoSnackBar(AppStrings.comingSoon),
          borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
          child: Row(
            children: [
              SvgPicture.asset(
                AppAssets.deliveryLocationIcon,
                width: AppDimens.chromeIconSize,
                height: AppDimens.chromeIconSize,
                colorFilter: const ColorFilter.mode(
                  AppColors.gray,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: AppDimens.space8),
              Flexible(
                child: Text.rich(
                  TextSpan(
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textMuted,
                      height: 1,
                    ),
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
              ),
              const SizedBox(width: AppDimens.space8),
              Transform.rotate(
                angle: -math.pi / 2,
                child: SvgPicture.asset(
                  AppAssets.chevronIcon,
                  width: AppDimens.iconSizeSmall,
                  height: AppDimens.iconSizeSmall,
                  colorFilter: const ColorFilter.mode(
                    AppColors.gray,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
