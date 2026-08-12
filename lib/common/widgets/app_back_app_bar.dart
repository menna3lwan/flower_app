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
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
      ),
      title: Text(title),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
