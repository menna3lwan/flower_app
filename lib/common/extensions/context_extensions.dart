import 'package:flutter/material.dart';

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

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
