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

  static const String flower1 = '$_imagesPath/product_placeholder_image.png';


  /// Brand icon (app icon / small mark).
  static const String appIcon = '$_iconsPath/flowery_icon.svg';
}
