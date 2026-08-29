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

  /// Home bottom navigation bar height.
  static const double bottomNavHeight = 56;

  /// Home category-chip icon box height.
  static const double categoryIconSize = 64;

  /// Home preview-card image height (best seller / occasion / products carousel).
  static const double productCardImageHeight = 151;

  /// Figma-verified width for Home's horizontal preview cards (best seller, occasion, products carousel all share this).
  static const double homeCardWidth = 131;

  /// Figma-verified Home search bar height (logo & search row).
  static const double searchBarHeight = 36;

  /// Figma-verified gap between the Flowery wordmark and the search field.
  static const double homeLogoToSearchGap = 17;

  /// Figma-verified icon size shared by the Home logo badge (circle diameter) and the delivery-location pin icon.
  static const double chromeIconSize = 20;

  /// Figma-verified inner leaf-glyph size inside the Home logo badge.
  static const double logoLeafSize = 12;

  /// Home category-chip column width (68×64, not square).
  static const double categoryChipWidth = 68;

  /// Figma Home categories row: icon(64) + gap(8) + 14px label at 17px line-box = 89.
  static const double categoryCardsRowHeight = 89;

  /// Figma Home occasion card: image(151) + gap(8) + 14px label at 17px line-box = 176.
  static const double occasionCardHeight = 176;

  /// Figma Home best-seller/carousel card: image(151) + gap(8) + name + gap(4) + price ≈ 195.
  static const double productPreviewCardHeight = 195;
}
