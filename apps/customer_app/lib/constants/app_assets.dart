/// Centralized registry of **customer-app-specific** asset paths — product
/// placeholders, illustrations, feature icons, and bundled translation
/// files. The shared brand mark (logo/app icon) lives in `design_system`'s
/// own `AppAssets`, not here — this file only ever holds assets that are
/// specific to `customer_app` and would have no meaning to the Rider app.
///
/// Assets synced from `development`'s flat `assets/` tree, preserving
/// their original file names.
abstract final class AppAssets {
  const AppAssets._();

  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _translationsPath = 'assets/translations';

  /// Product/marketing photography and illustration placeholders. Individual
  /// files are not enumerated here (mirrors `development`'s own registry,
  /// which only tracked path prefixes for this bucket) — reference a file
  /// directly as `'${AppAssets.imagesPath}/<file_name>'`.
  static const String imagesPath = _imagesPath;

  /// Custom feature icon assets (SVG) — prefer `Icons.xxx`/`CupertinoIcons.xxx`
  /// wherever Material/Cupertino already covers the glyph.
  static const String iconsPath = _iconsPath;

  /// Bundled translation JSON files (`ar.json`, `en.json`) synced from
  /// `development`. Not wired into a localization pipeline yet — see
  /// `AppStrings` for the copy currently in use.
  static const String translationsPath = _translationsPath;
}
