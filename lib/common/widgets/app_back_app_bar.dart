import 'package:flutter/material.dart';

/// The recurring "< Title" app bar used on every non-tab screen (Login, Product details, Cart, ...).
class AppBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBackAppBar({
    required this.title,
    this.actions,
    this.onBackTap,
    super.key,
  });

  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AppBar(
      leading: IconButton(
        // Mirror the back arrow in RTL when the platform glyph itself does not flip automatically.
        icon: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(isRtl ? 3.141592653589793 : 0),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
      ),
      title: Text(title),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
