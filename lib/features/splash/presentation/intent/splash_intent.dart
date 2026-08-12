/// Every user/system action the Splash screen can dispatch to [SplashCubit.handleIntent].
sealed class SplashIntent {
  const SplashIntent();
}

/// Dispatched once when the Splash screen first appears.
final class SplashStarted extends SplashIntent {
  const SplashStarted();
}

/// Dispatched when the user taps retry after a failed initialization.
final class SplashRetried extends SplashIntent {
  const SplashRetried();
}
