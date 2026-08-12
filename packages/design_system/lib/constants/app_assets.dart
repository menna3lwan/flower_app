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

  /// The Flowery brand mark. Add the exported Figma asset at
  /// `packages/design_system/assets/images/logo.png` to back this path.
  static const String logo = '$_imagesPath/logo.png';

  /// Brand icon (app icon / small mark). Add the exported Figma asset at
  /// `packages/design_system/assets/icons/app_icon.png` to back this path.
  static const String appIcon = '$_iconsPath/app_icon.png';
}
