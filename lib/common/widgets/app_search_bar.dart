import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';

class AppSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppSearchAppBar({
    super.key,
    this.onSearchChanged,
    this.onFilterTap,
    this.hintText = 'Search',
  });

  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFilterTap;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 0,
      toolbarHeight: 78,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: AppDimens.space48,
                child: TextField(
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.placeholderGray,
                    ),
                    prefixIcon: SvgPicture.asset(
                      AppAssets.appSearchIcon,
                      color: AppColors.placeholderGray,
                      width: AppDimens.iconSize,
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 60),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusSmall,
                      ),
                      borderSide: const BorderSide(color: AppColors.gray),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusSmall,
                      ),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ),

            const Gap(AppDimens.space12),

            SizedBox(
              width: AppDimens.space64,
              height: AppDimens.space48,
              child: OutlinedButton(
                onPressed: onFilterTap,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: const BorderSide(color: AppColors.placeholderGray),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                  ),
                ),
                child: SvgPicture.asset(
                  AppAssets.appSortIcon,
                  color: AppColors.placeholderGray,
                  width: AppDimens.iconSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
