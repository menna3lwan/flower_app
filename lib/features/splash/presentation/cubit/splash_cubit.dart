import '../../../../core/base/base_cubit.dart';
import '../../../../core/constants/app_durations.dart';
import '../../domain/repositories/splash_repository.dart';
import '../intent/splash_intent.dart';
import '../state/splash_state.dart';

/// State handler for the Splash screen: the View dispatches [SplashIntent]s here via [handleIntent], never calling domain code directly.
class SplashCubit extends BaseCubit<SplashState> {
  SplashCubit(this._splashRepository) : super(const SplashInitial());

  final SplashRepository _splashRepository;

  Future<void> handleIntent(SplashIntent intent) {
    return switch (intent) {
      SplashStarted() || SplashRetried() => _initialize(),
    };
  }

  Future<void> _initialize() async {
    safeEmit(const SplashInitializing());
    await Future.delayed(AppDurations.splashDisplay);
    final result = await _splashRepository.resolveDestination();
    result.fold(
      (failure) => safeEmit(SplashFailed(failure.message)),
      (destination) => safeEmit(SplashReady(destination)),
    );
  }
}
