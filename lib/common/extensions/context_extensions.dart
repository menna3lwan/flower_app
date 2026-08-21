import 'package:flutter/material.dart';

import 'package:customer_app/core/constants/app_colors.dart';

/// Small ergonomics layer over [BuildContext] so widgets read
/// `context.textTheme` / `context.screenWidth` instead of the more
/// verbose `Theme.of(context).textTheme`.
///
/// Lives in `common` (not `core`) because it is inherently tied to the
/// Flutter widget tree ([BuildContext], [ScaffoldMessenger]) — `core`
/// stays framework-agnostic wherever practical.
extension ContextExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  void showSnackBar(String message) => _showSnackBar(message);

  /// Failure feedback — API errors and rejected submissions.
  void showErrorSnackBar(String message) =>
      _showSnackBar(message, background: AppColors.error);

  /// Confirmation feedback — e.g. account created, password reset.
  void showSuccessSnackBar(String message) =>
      _showSnackBar(message, background: AppColors.success);

  void _showSnackBar(String message, {Color? background}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: background == null
                ? null
                : const TextStyle(color: AppColors.onPrimary),
          ),
          backgroundColor: background,
        ),
      );
  }
}
