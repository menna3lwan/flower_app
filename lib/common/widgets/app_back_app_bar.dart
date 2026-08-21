import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

class AppBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBackAppBar({
    required this.title,
    this.actions,
    this.onBackTap,
    this.titleStyle,
    super.key,
  });

  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackTap;

  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return AppBar(
      leadingWidth: 36,
      titleSpacing: 8,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Transform.flip(
            flipX: isRtl,
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
          onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
        ),
      ),
      title: Text(title, style: titleStyle ?? AppTextStyles.appBarTitleEmphasis),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
