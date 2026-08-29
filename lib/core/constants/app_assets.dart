/// Centralized real asset paths; widgets read constants here instead of hardcoding raw paths.
abstract final class AppAssets {
  const AppAssets._();

  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _translationsPath = 'assets/translations';

  static const String imagesPath = _imagesPath;

  static const String iconsPath = _iconsPath;

  static const String translationsPath = _translationsPath;

  /// The Flowery brand mark.
  static const String logo = '$_imagesPath/flower_app_logo.png';

  /// Brand icon (app icon / small mark) — also used inline as the Home app-bar logo glyph.
  static const String appIcon = '$_iconsPath/flowery_icon.svg';

  // Home — category chip icons (Figma-verified assets, already bundled).
  static const String categoryFlowersIcon = '$_iconsPath/tulip_icon.svg';
  static const String categoryGiftIcon = '$_iconsPath/gift.svg';
  static const String categoryDiamondIcon = '$_iconsPath/diamond_icon.svg';

  // Home — static chrome icons.
  static const String searchIcon = '$_iconsPath/search_icon.svg';
  static const String deliveryLocationIcon = '$_iconsPath/location_pin_icon.svg';

  // Home — bottom navigation icons.
  static const String navHomeIcon = '$_iconsPath/home_icon.svg';
  static const String navCategoriesIcon = '$_iconsPath/category_icon.svg';
  static const String navCartIcon = '$_iconsPath/cart_icon.svg';
  static const String navProfileIcon = '$_iconsPath/person_icon.svg';

  /// Home — delivery-location row's trailing chevron; Figma builds it by rotating this same "<" glyph -90°.
  static const String chevronIcon = '$_iconsPath/back_icon.svg';
}
