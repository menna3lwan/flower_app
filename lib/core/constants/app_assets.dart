/// Centralized registry of every real asset path used by the app —
/// product/UI images, icons, translations, and the Flowery brand mark.
/// A widget never hardcodes a raw asset path string; it reads a constant
/// from here instead, so a renamed or moved file only needs a single
/// update.
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

  /// Brand icon (app icon / small mark).
  static const String appIcon = '$_iconsPath/flowery_icon.svg';
}
