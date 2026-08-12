/// Lottie-style animation asset paths, synced from `development`
/// (`assets/animations/`).
///
/// Not yet wired to a Lottie-rendering widget/dependency — see the final
/// asset-sync report for what's still required before these render.
abstract final class AppAnimations {
  const AppAnimations._();

  static const String _animationsPath = 'assets/animations';

  static const String loading = '$_animationsPath/loading_animation.json';
  static const String success = '$_animationsPath/success_animation.json';
  static const String error = '$_animationsPath/error_animation.json';
}
