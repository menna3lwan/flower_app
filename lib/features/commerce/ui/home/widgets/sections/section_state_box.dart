import 'package:flutter/material.dart';

import 'package:customer_app/common/widgets/states/empty_state.dart';
import 'package:customer_app/common/widgets/states/error_view.dart';
import 'package:customer_app/core/constants/app_dimens.dart';
import 'package:customer_app/core/localization/app_strings.dart';

/// Reuses [EmptyState]/[ErrorView] inside a bounded-height box, so one failed/empty section never collapses or grows unbounded in Home's list.
class SectionStateBox extends StatelessWidget {
  const SectionStateBox.empty({required this.message, super.key})
      : isError = false,
        onRetry = null;

  const SectionStateBox.error({required this.message, this.onRetry, super.key})
      : isError = true;

  final String message;
  final bool isError;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.productCardImageHeight,
      child: isError
          ? ErrorView(
              message: message,
              onRetry: onRetry,
              retryLabel: onRetry == null ? null : AppStrings.retry,
            )
          : EmptyState(message: message, icon: Icons.inbox_outlined),
    );
  }
}
