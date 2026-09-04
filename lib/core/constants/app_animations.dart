/// Lottie animation asset paths (`assets/animations/`) — not yet wired to a rendering widget/dependency.
abstract final class AppAnimations {
  const AppAnimations._();

  static const String _animationsPath = 'assets/animations';

  static const String loading = '$_animationsPath/loading_animation.json';
  static const String success = '$_animationsPath/success_animation.json';
  static const String error = '$_animationsPath/error_animation.json';
}
