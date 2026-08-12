/// Centralized asset path registry — never hardcode an asset path string outside this file.
abstract final class AppAssets {
  const AppAssets._();

  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _illustrationsPath = 'assets/illustrations';
  static const String _animationsPath = 'assets/animations';

  // Logos.
  /// The Flowery brand mark — real asset extracted from Figma, used on the Splash screen.
  static const String appLogo = '$_imagesPath/flower_app_logo.png';

  // Illustrations (decorative, branded — not photography).
  /// Pink wave shape behind the checkmark on the order-confirmation screen.
  static const String successWaveBackground = '$_illustrationsPath/success_wave_bg.png';

  /// Car graphic on the Track order screen.
  static const String deliveryCarIllustration = '$_illustrationsPath/delivery_car.png';

  // Images (product/marketing photography) — none bundled; see class doc.
  static const String imagesPath = _imagesPath;

  // Custom icon assets only — prefer Icons.xxx/CupertinoIcons.xxx where Material already covers it.
  static const String iconsPath = _iconsPath;

  // Animations (Lottie or similar) — none in use yet.
  static const String animationsPath = _animationsPath;
}
