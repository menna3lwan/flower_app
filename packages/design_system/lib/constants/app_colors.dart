import 'package:flutter/material.dart';

abstract final class AppColors {
  const AppColors._();
  static const Color primary = Color(0xFFD21E6A);
  static const Color primaryDark = Color(0xFFB4275A);
  static const Color primaryLight = Color(0xFFFBE4EA);

  /// Neutral surfaces.
  static const Color background = Color(0xFFF9F9F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE7E7E7);

  /// System Colors page.
  static const Color textPrimary = Color(0xFF0C1015);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFACACAC);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFCC1010);
  static const Color success = Color(0xFF0CB359);
  static const Color warning = Color(0xFFF9A825);

  /// border color.
  static const Color gray = Color(0xFF535353);
  static const Color black = Color(0xFF0C1015);
  static const Color white = Color(0xFFFFFFFF);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color starRating = Color(0xFFFFB800);
}
