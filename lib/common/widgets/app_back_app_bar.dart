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
    // `Icons.arrow_back_ios_new_rounded` doesn't auto-mirror under RTL —
    // unlike Flutter's built-in `BackButtonIcon`, a plain `Icon` with this
    // glyph has no `matchTextDirection` behavior, so without this it kept
    // pointing left in Arabic instead of right. Fixed once here since
    // every auth screen (Login, Sign Up, Forgot Password, OTP, Reset
    // Password) shares this one AppBar.
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return AppBar(
      leading: IconButton(
        icon: Transform.flip(
          flipX: isRtl,
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
      ),
      // Figma Dev Mode confirmed this 20px/w500 style on the Login frame's
      // AppBar title (see AppTextStyles.appBarTitleEmphasis). All five auth
      // screens (Login, Sign Up, Forgot Password, OTP, Reset Password)
      // share this one AppBackAppBar, so the correct fix is a shared
      // default here rather than each call site repeating the override.
      title: Text(title, style: titleStyle ?? AppTextStyles.appBarTitleEmphasis),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
