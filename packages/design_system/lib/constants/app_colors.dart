import 'package:flutter/material.dart';

/// Centralized color palette extracted from the Flower App Figma design
/// (Design System > Color styles: Main color, Light pink, Gray, Error,
/// Success, White, Black).
///
/// Single source of truth for color — never hardcode a `Color(0x...)`
/// inside a widget, reference [AppColors] instead.
abstract final class AppColors {
  const AppColors._();

  /// Brand main color — primary buttons, active tabs, links, price tags.
  static const Color primary = Color(0xFFD6336C);
  static const Color primaryDark = Color(0xFFB4275A);
  static const Color primaryLight = Color(0xFFFBE4EA);

  /// Neutral surfaces.
  static const Color background = Color(0xFFF9F9F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE7E7E7);

  /// Text.
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFACACAC);
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Semantic.
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFF9A825);

  /// Misc.
  static const Color gray = Color(0xFF9E9E9E);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color starRating = Color(0xFFFFB800);
}
