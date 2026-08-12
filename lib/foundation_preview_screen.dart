import 'package:flutter/material.dart';

import 'common/dialogs/confirm_dialog.dart';
import 'common/extensions/localization_extensions.dart';
import 'common/widgets/app_section_header.dart';
import 'common/widgets/buttons/primary_button.dart';
import 'common/widgets/buttons/secondary_button.dart';
import 'common/widgets/media/app_image_placeholder.dart';
import 'common/widgets/states/empty_state.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_dimens.dart';
import 'core/di/injector.dart';
import 'core/localization/locale_controller.dart';
import 'core/localization/supported_locales.dart';
import 'core/theme/app_text_styles.dart';

/// Temporary scaffolding proving `core`/`common`/`assets` compile and render together; delete once features wire in.
class FoundationPreviewScreen extends StatelessWidget {
  const FoundationPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentLocale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.foundationPreviewTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppDimens.space16),
          children: [
            Text(l10n.foundationPreviewHeading, style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppDimens.space8),
            Text(l10n.foundationPreviewBody, style: AppTextStyles.bodyMedium),
            const SizedBox(height: AppDimens.space24),
            AppSectionHeader(title: l10n.foundationLanguageSection, subtitle: 'core/localization — EN/AR, RTL'),
            const SizedBox(height: AppDimens.space12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
              child: Wrap(
                spacing: AppDimens.space8,
                children: SupportedLocales.all.map((locale) {
                  final isSelected = locale.languageCode == currentLocale.languageCode;
                  return ChoiceChip(
                    label: Text(locale.languageCode == 'ar' ? 'العربية' : 'English'),
                    selected: isSelected,
                    onSelected: (_) => sl<LocaleController>().changeLocale(locale),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppDimens.space24),
            AppSectionHeader(title: l10n.foundationTypographySection, subtitle: 'core/theme, core/constants'),
            const SizedBox(height: AppDimens.space12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.space16),
              child: Wrap(
                spacing: AppDimens.space8,
                runSpacing: AppDimens.space8,
                children: [
                  _ColorSwatch(label: 'primary', color: AppColors.primary),
                  _ColorSwatch(label: 'primaryLight', color: AppColors.primaryLight),
                  _ColorSwatch(label: 'success', color: AppColors.success),
                  _ColorSwatch(label: 'error', color: AppColors.error),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.space24),
            AppSectionHeader(title: l10n.foundationButtonsSection, subtitle: 'common/widgets/buttons'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
              child: Column(
                children: [
                  PrimaryButton(label: l10n.foundationPrimaryButton, onPressed: () {}),
                  const SizedBox(height: AppDimens.space12),
                  SecondaryButton(label: l10n.foundationSecondaryButton, onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.space24),
            AppSectionHeader(title: l10n.foundationImageSection, subtitle: 'common/widgets/media'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.space16),
              child: SizedBox(
                height: AppDimens.productCardImageHeight,
                child: AppImagePlaceholder(),
              ),
            ),
            const SizedBox(height: AppDimens.space24),
            AppSectionHeader(title: l10n.foundationEmptyStateSection, subtitle: 'common/widgets/states'),
            EmptyState(message: l10n.foundationEmptyStateMessage),
            const SizedBox(height: AppDimens.space24),
            AppSectionHeader(title: l10n.foundationDialogSection, subtitle: 'common/dialogs'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.space16),
              child: OutlinedButton(
                onPressed: () => showConfirmDialog(
                  context,
                  title: l10n.foundationDialogTitle,
                  message: l10n.foundationDialogMessage,
                ),
                child: Text(l10n.foundationShowDialogButton),
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
        const SizedBox(height: AppDimens.space4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
