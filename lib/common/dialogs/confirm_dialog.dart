import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';
import '../widgets/buttons/primary_button.dart';

/// Generic two-action confirmation dialog (title, message, Cancel /
/// Confirm) — e.g. the "LOGOUT — Confirm logout!!" dialog in the Figma
/// Profile screen. `showConfirmDialog` returns `true` only when the
/// user tapped the confirm action, `false`/`null` otherwise, so callers
/// can `if (await showConfirmDialog(...)) { ... }`.
///
/// `confirmLabel`/`cancelLabel` are required (not defaulted) on purpose:
/// this lives in the shared `common` package, which must never depend on
/// an application's own copy deck (see monorepo dependency rules) — each
/// app passes its own localized strings at the call site instead.
Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => ConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    ),
  );
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    super.key,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusLarge)),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppTextStyles.titleLarge),
            const SizedBox(height: AppDimens.space8),
            Text(message, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: AppDimens.space24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(cancelLabel),
                  ),
                ),
                const SizedBox(width: AppDimens.space12),
                Expanded(
                  child: PrimaryButton(
                    label: confirmLabel,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
