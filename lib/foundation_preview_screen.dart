import 'package:flutter/material.dart';

import 'package:customer_app/common/dialogs/confirm_dialog.dart';
import 'package:customer_app/common/widgets/app_section_header.dart';
import 'package:customer_app/core/localization/app_strings.dart';
import 'package:customer_app/common/widgets/buttons/primary_button.dart';
import 'package:customer_app/common/widgets/buttons/secondary_button.dart';
import 'package:customer_app/common/widgets/media/app_image_placeholder.dart';
import 'package:customer_app/common/widgets/states/empty_state.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/theme/app_text_styles.dart';

/// Temporary landing screen proving the `core`/`common`/`assets`
/// foundation actually compiles and renders together — theme, shared
/// widgets, dialogs, and the image placeholder.
///
/// **This is scaffolding, not a feature.** It has no Cubit, no state, no
/// navigation target of its own; it exists only until the first real
/// feature (Splash → Login → ...) is wired into [CustomerPages], at which
/// point it should be deleted and `FlowerApp.home` replaced with
/// `initialRoute`.
class FoundationPreviewScreen extends StatelessWidget {
  const FoundationPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foundation preview')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppDimens.space16),
          children: [
            Text('Core + Common + Assets', style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppDimens.space8),
            Text(
              'This screen only exercises the shared foundation — no feature '
              'business logic runs here.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppDimens.space24),
            const AppSectionHeader(
                title: 'Typography & color',
                subtitle: 'core/theme, core/constants'),
            const SizedBox(height: AppDimens.space12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.space16),
              child: Wrap(
                spacing: AppDimens.space8,
                runSpacing: AppDimens.space8,
                children: [
                  _ColorSwatch(label: 'primary', color: AppColors.primary),
                  _ColorSwatch(
                      label: 'primaryLight', color: AppColors.primaryLight),
                  _ColorSwatch(label: 'success', color: AppColors.success),
                  _ColorSwatch(label: 'error', color: AppColors.error),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.space24),
            const AppSectionHeader(
                title: 'Buttons', subtitle: 'common/widgets/buttons'),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimens.space16),
              child: Column(
                children: [
                  PrimaryButton(label: 'Primary button', onPressed: () {}),
                  const SizedBox(height: AppDimens.space12),
                  SecondaryButton(label: 'Secondary button', onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.space24),
            const AppSectionHeader(
                title: 'Image placeholder', subtitle: 'common/widgets/media'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.space16),
              child: SizedBox(
                height: AppDimens.productCardImageHeight,
                child: AppImagePlaceholder(),
              ),
            ),
            const SizedBox(height: AppDimens.space24),
            const AppSectionHeader(
                title: 'Empty state', subtitle: 'common/widgets/states'),
            const EmptyState(
                message:
                    'Nothing here yet — this is a shared, reusable state.'),
            const SizedBox(height: AppDimens.space24),
            const AppSectionHeader(title: 'Dialog', subtitle: 'common/dialogs'),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimens.space16),
              child: OutlinedButton(
                onPressed: () => showConfirmDialog(
                  context,
                  title: 'Confirm',
                  message: 'This dialog is a shared common/ component.',
                  confirmLabel: AppStrings.confirmLogout,
                  cancelLabel: AppStrings.cancel,
                ),
                child: const Text('Show confirm dialog'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
            border: Border.all(color: AppColors.divider),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
