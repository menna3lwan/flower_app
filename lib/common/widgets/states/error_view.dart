import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../extensions/localization_extensions.dart';
import '../buttons/primary_button.dart';

/// Shared full-screen error state with an optional retry action, so every feature's `Error` variant matches.
class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.message,
    this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: AppDimens.space16),
            Text(message, textAlign: TextAlign.center, style: AppTextStyles.bodyLarge),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimens.space24),
              PrimaryButton(label: context.l10n.retry, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
