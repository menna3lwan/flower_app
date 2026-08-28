import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
/// Feedback categories for Auth screens, not tied to HTTP/Failure types, so e.g. an `info` banner can be shown for non-failures.
enum AuthMessageType { success, error, warning, info }

/// Visual spec (accent color + icon) for one [AuthMessageType], kept as data instead of scattering switches.
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

/// Self-contained feedback card (icon + message + accent stripe) used as SnackBar content instead of the default look.
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
