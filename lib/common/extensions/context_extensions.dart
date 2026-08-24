import 'package:flutter/material.dart';

import 'package:customer_app/common/widgets/feedback/auth_message_banner.dart';
import 'package:customer_app/core/constants/app_dimens.dart';

/// Ergonomics layer over [BuildContext]; lives in `common` (not `core`) since it's tied to the Flutter widget tree.
extension ContextExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  /// Shows the shared [AuthMessageBanner] as floating SnackBar content — the app's standard feedback surface.
  void showAuthMessage(AuthMessageType type, String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: AuthMessageBanner(type: type, message: message),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space16,
          ),
          duration: const Duration(seconds: 4),
        ),
      );
  }

  /// Failure feedback — API errors and rejected submissions.
  void showErrorSnackBar(String message) =>
      showAuthMessage(AuthMessageType.error, message);

  /// Confirmation feedback — e.g. account created, password reset.
  void showSuccessSnackBar(String message) =>
      showAuthMessage(AuthMessageType.success, message);

  /// Non-blocking heads-up that isn't a failure — e.g. rate-limited, please wait.
  void showWarningSnackBar(String message) =>
      showAuthMessage(AuthMessageType.warning, message);

  /// Neutral confirmation of a background action — e.g. "code resent".
  void showInfoSnackBar(String message) =>
      showAuthMessage(AuthMessageType.info, message);
}
