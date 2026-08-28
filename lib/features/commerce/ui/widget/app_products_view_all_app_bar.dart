import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';

class AppProductsViewAllAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AppProductsViewAllAppBar({
    super.key,
    this.onBackTap,
    required this.title,
    required this.subtitle,
  });

  final VoidCallback? onBackTap;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      leadingWidth: AppDimens.space48,
      leading: IconButton(
        padding: EdgeInsets.zero,
        icon: Transform.flip(
          flipX: !isRtl,
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
      ),
      titleSpacing: 0,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.appBarTitleEmphasis.copyWith(height: 1),
          ),
          Text(
            subtitle,
            style: AppTextStyles.bodyExtraSmall.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.gray,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
