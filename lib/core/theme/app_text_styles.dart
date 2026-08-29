import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

abstract final class AppTextStyles {
  const AppTextStyles._();

  /// The design system's typeface, bundled locally — `GoogleFonts.inter()` used to fetch it from the network on first paint even offline.
  static const String fontFamily = 'Inter';

  static TextStyle get _base => const TextStyle(
        fontFamily: fontFamily,
        color: AppColors.textPrimary,
      );

  static TextStyle get displayLarge => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineMedium => _base.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get titleLarge => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleMedium => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get appBarTitleEmphasis => _base.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get bodyLarge => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodyMedium => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodySmall => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodyExtraSmall => _base.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get labelLarge => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.onPrimary,
      );

  static TextStyle get labelMedium => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  /// Figma-verified Home section header title (Categories/Best seller/Occasion) — 18px medium, distinct from [titleLarge] (18px semibold) so other [titleLarge] callers stay unaffected.
  static TextStyle get sectionTitle => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      );

  /// Figma-verified Home section "View All" link — 12px medium underline, distinct from [link] (14px semibold) so other [link] callers stay unaffected.
  static TextStyle get sectionViewAll => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
        decoration: TextDecoration.underline,
      );

  /// The Figma logo wordmark's display face — bundled as `assets/fonts/IMFellEnglish.ttf`, registered only for this one use (the Home/Splash "Flowery" mark), never for body text.
  static const String logoFontFamily = 'IMFellEnglish';

  /// Figma-verified Home "Flowery" wordmark style — 20px, brand color, the dedicated logo face.
  static TextStyle get logoWordmark => const TextStyle(
        fontFamily: logoFontFamily,
        fontSize: 20,
        color: AppColors.primary,
      );

  /// Figma-verified [ProductCard] title (Best seller / Products carousel) — 12px regular, primary text
  /// color; distinct from [bodySmall] (same size but [AppColors.textSecondary]).
  static TextStyle get productCardTitle => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get caption => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get price => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      );

  static TextStyle get link => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        decoration: TextDecoration.underline,
      );
}
