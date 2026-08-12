import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../domain/entities/splash_destination.dart';
import '../../domain/repositories/splash_repository.dart';

const String _authTokenStorageKey = 'auth_token';

/// Resolves the post-splash destination from local storage; no remote call per the reviewed API spec (splash has no endpoint).
class SplashRepositoryImpl implements SplashRepository {
  const SplashRepositoryImpl(this._localStorageService);

  final LocalStorageService _localStorageService;

  @override
  Future<Result<SplashDestination>> resolveDestination() async {
    try {
      // No feature persists a session token yet, so this always resolves to login until auth persistence exists.
      await _localStorageService.getString(_authTokenStorageKey);
      return Result.success(SplashDestination.login);
    } catch (_) {
      return  Result.failure(UnexpectedFailure());
    }
  }
}
