import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';
import '../buttons/primary_button.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.message,
    this.onRetry,
    this.retryLabel,
    super.key,
  });

  final String message;
  final VoidCallback? onRetry;

  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: AppColors.error),
            const SizedBox(height: AppDimens.space16),
            Text(message,
                textAlign: TextAlign.center, style: AppTextStyles.bodyLarge),
            if (onRetry != null && retryLabel != null) ...[
              const SizedBox(height: AppDimens.space24),
              PrimaryButton(label: retryLabel!, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
