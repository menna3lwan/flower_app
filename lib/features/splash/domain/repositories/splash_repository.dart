import '../../../../core/result/result.dart';
import '../entities/splash_destination.dart';

/// Contract the presentation layer depends on, never a concrete impl directly (DIP).
abstract interface class SplashRepository {
  Future<Result<SplashDestination>> resolveDestination();
}
