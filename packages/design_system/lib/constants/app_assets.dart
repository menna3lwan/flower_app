/// Centralized registry of every **shared brand asset** path — logo and
/// brand icon only. Product photography, marketing images, and any other
/// app-specific asset lives in that app's own `AppAssets`, not here; this
/// package is a dependency of both `customer_app` and `rider_app`, so it
/// must only ever hold assets both apps legitimately share.
///
/// Paths are package-relative (`packages/design_system/assets/...`) per
/// Flutter's package-asset convention — a consuming app does not need to
/// redeclare these in its own `pubspec.yaml` `assets:` list, only depend
/// on this package.
abstract final class AppAssets {
  const AppAssets._();

  static const String _imagesPath = 'packages/design_system/assets/images';
  static const String _iconsPath = 'packages/design_system/assets/icons';

  /// The Flowery brand mark — real asset synced from `development`
  /// (`assets/images/flower_app_logo.png` there).
  static const String logo = '$_imagesPath/flower_app_logo.png';

  /// Brand icon (app icon / small mark) — real asset synced from
  /// `development` (`assets/images/flowery_icon.svg` there; moved under
  /// this package's `assets/icons/` to match its role).
  static const String appIcon = '$_iconsPath/flowery_icon.svg';
}
