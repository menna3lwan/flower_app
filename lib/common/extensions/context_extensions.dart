import 'package:flutter/material.dart';

import 'package:customer_app/common/widgets/feedback/auth_message_banner.dart';
import 'package:customer_app/core/constants/app_dimens.dart';

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

  /// Shows the shared [AuthMessageBanner] as floating, borderless
  /// SnackBar content — the one feedback surface every Auth screen (and
  /// anything else that wants it) should use instead of a plain default
  /// SnackBar.
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

  /// Non-blocking heads-up that isn't a failure — e.g. rate-limited,
  /// please wait.
  void showWarningSnackBar(String message) =>
      showAuthMessage(AuthMessageType.warning, message);

  /// Neutral confirmation of a background action — e.g. "code resent".
  void showInfoSnackBar(String message) =>
      showAuthMessage(AuthMessageType.info, message);
}
