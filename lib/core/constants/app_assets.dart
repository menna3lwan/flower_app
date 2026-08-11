/// Centralized registry of every static asset path in the app.
///
/// **Rule: no widget ever writes an asset path string literal.** Add the
/// path here once, then reference `AppAssets.xxx` everywhere it's used —
/// this is what makes a future rename/reorganization of `assets/` a
/// one-file change instead of a project-wide find-and-replace, and lets
/// the analyzer catch a typo'd asset name at the call site instead of a
/// runtime "unable to load asset" failure.
///
/// Organized by asset type (images / icons / fonts / animations), not by
/// feature — see `assets/` folder structure.
abstract final class AppAssets {
  const AppAssets._();

  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _animationsPath = 'assets/animations';

  // Images.
  // No product/marketing photography ships with this UI skeleton yet —
  // see `common/widgets/media/app_image_placeholder.dart` for the
  // decorative placeholder every image slot currently renders. Add real
  // entries here as design assets are exported from Figma, e.g.:
  // static const String onboardingHero = '$_imagesPath/onboarding_hero.png';
  static const String logo = '$_imagesPath/logo.png';

  // Icons (custom, non-Material icon assets only — prefer
  // `Icons.xxx`/`CupertinoIcons.xxx` for anything Material already
  // covers, which is everything used in this skeleton so far).
  static const String appIcon = '$_iconsPath/app_icon.png';

  // Animations (Lottie or similar) — none in use yet.
  static const String placeholderLottiePath = _animationsPath;
}
