abstract final class AppDimens {
  const AppDimens._();

  // Spacing scale.
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;

  static const double space48 = 48;
  static const double labelToFieldGap = 6;

  /// Verification-screen OTP box size (Pinput's per-digit box theme).
  static const double otpBoxWidth = 74;
  static const double otpBoxHeight = 68;

  static const double radiusExtraSmall = 4;
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;

  /// Figma-verified: Home category-chip corner radius.
  static const double radiusExtraLarge = 20;
  static const double radiusPill = 100;

  static const double buttonHeight = 48;
  static const double inputHeight = 56;
  static const double iconSize = 24;
  /// Small inline icon — e.g. the ✓/✕ markers in [PasswordRulesChecklist].
  static const double iconSizeSmall = 16;
  static const double avatarSize = 88;

  /// Figma-verified Home bottom navigation bar height (was an unused, unverified 64 before).
  static const double bottomNavHeight = 56;

  /// Figma-verified Home category-chip icon circle size (was an unverified 56 before).
  static const double categoryIconSize = 64;

  /// Figma-verified Home preview-card image height (best seller / occasion / products carousel) — was an unverified 160 before.
  static const double productCardImageHeight = 151;

  /// Figma-verified width for Home's horizontal preview cards (best seller, occasion, products carousel all share this).
  static const double homeCardWidth = 131;

  /// Figma-verified Home search bar height (logo & search row).
  static const double searchBarHeight = 36;

  /// Figma-verified icon size shared by the Home logo badge (circle diameter) and the delivery-location pin icon.
  static const double chromeIconSize = 20;

  /// Figma-verified inner leaf-glyph size inside the Home logo badge.
  static const double logoLeafSize = 12;

  /// Figma-verified Home category-chip column width (68) — distinct from [categoryIconSize] (64):
  /// the chip box is 68 wide × 64 tall, not square.
  static const double categoryChipWidth = 68;

  /// Figma-verified Home categories horizontal row height: icon(64) + gap(8) + one-line label,
  /// +4 over the Figma-measured 89 since Flutter's default text line-height renders taller than Figma's.
  static const double categoryCardsRowHeight = 93;

  /// Figma-verified Home occasion-card total height: image(151) + gap(8) + one-line label,
  /// +4 over the Figma-measured 176 for the same Flutter/Figma line-height difference.
  static const double occasionCardHeight = 180;

  /// Figma-verified Home best-seller/products-carousel card total height: image(151) + gap(8) + two-line name+price,
  /// +6 over the Figma-measured 195 for the same Flutter/Figma line-height difference.
  static const double productPreviewCardHeight = 201;
}
