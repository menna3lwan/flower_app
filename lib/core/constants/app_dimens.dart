/// Spacing, radius, and sizing tokens — never hardcode a raw pixel value that duplicates one of these.
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

  // Radius scale.
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusPill = 100;

  // Component sizing.
  static const double buttonHeight = 56;
  static const double inputHeight = 56;
  static const double iconSize = 24;
  static const double iconSizeLarge = 72;
  static const double avatarSize = 88;
  static const double bottomNavHeight = 64;
  static const double categoryIconSize = 56;
  static const double productCardImageHeight = 160;
}
