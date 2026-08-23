import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

/// The four feedback categories the Auth flow (and, going forward, any
/// other feature) needs — deliberately not tied to HTTP status codes or
/// [Failure] subtypes, so a screen can also show e.g. an `info` banner
/// for "OTP resent" without that being a failure at all.
enum AuthMessageType { success, error, warning, info }

/// A compact visual spec for one [AuthMessageType] — the accent color,
/// tinted background, and icon it renders with. Kept as one small record
/// per type instead of scattering `switch`es across the banner and any
/// future consumer (e.g. an inline variant).
class _MessageStyle {
  const _MessageStyle({
    required this.accent,
    required this.icon,
  });

  final Color accent;
  final IconData icon;
}

_MessageStyle _styleFor(AuthMessageType type) => switch (type) {
      AuthMessageType.success => const _MessageStyle(
          accent: AppColors.success,
          icon: Icons.check_circle_rounded,
        ),
      AuthMessageType.error => const _MessageStyle(
          accent: AppColors.error,
          icon: Icons.error_rounded,
        ),
      AuthMessageType.warning => const _MessageStyle(
          accent: AppColors.warning,
          icon: Icons.warning_rounded,
        ),
      AuthMessageType.info => const _MessageStyle(
          accent: AppColors.primary,
          icon: Icons.info_rounded,
        ),
    };

/// A modern, self-contained feedback card — an icon in a tinted circle,
/// the message, and a left accent stripe — used as the *content* of a
/// floating [SnackBar] (see `context_extensions.dart`'s `showAuthMessage`)
/// so it replaces the plain solid-color default SnackBar look everywhere
/// Auth reports success/error/warning/info, without introducing a new
/// overlay/toast package.
class AuthMessageBanner extends StatelessWidget {
  const AuthMessageBanner({
    required this.type,
    required this.message,
    super.key,
  });

  final AuthMessageType type;
  final String message;

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(type);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: Border(
          left: BorderSide(color: style.accent, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space12,
        vertical: AppDimens.space12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(style.icon, color: style.accent, size: AppDimens.iconSize),
          const SizedBox(width: AppDimens.space12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
