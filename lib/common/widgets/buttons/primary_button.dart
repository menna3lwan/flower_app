import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_dimens.dart';

/// Full-width, pill-shaped filled button — the "Login" / "Checkout" /
/// "Place order" style button used throughout the design.
///
/// Centralizing the loading-spinner-vs-label swap here means every
/// submit-style button in the app gets consistent disabled/loading
/// behavior for free, instead of each screen reimplementing it.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: AppDimens.iconSize),
                  const SizedBox(width: AppDimens.space8),
                ],
                Text(label),
              ],
            ),
    );
  }
}
