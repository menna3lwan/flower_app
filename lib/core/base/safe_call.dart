import '../network/error_parser.dart';
import '../result/result.dart';

/// The one place a data-layer call that can throw gets turned into a
/// [Result] — every repository in the app should call this instead of
/// writing its own `try { ... } catch (e) { ... }`.
///
/// Before this existed, `AuthRepositoryImpl` had its own private
/// `_guard`/`_mapException` pair, and every future repository would have
/// needed to copy-paste the same shape. Now there is exactly one
/// implementation: run [operation], and if it throws, hand the error to
/// [ErrorParser] (which already knows how to read both Retrofit's raw
/// `DioException`s and this project's legacy typed exceptions) to become
/// a typed [Failure] instead of leaking past the data layer.
///
/// Usage (see `AuthRepositoryImpl`):
/// ```dart
/// @override
/// Future<Result<UserEntity>> login({required String email, required String password}) {
///   return safeCall(() => _dataSource.login(email: email, password: password));
/// }
/// ```
Future<Result<T>> safeCall<T>(Future<T> Function() operation) async {
  try {
    final data = await operation();
    return Result.success(data);
  } catch (error, stackTrace) {
    return Result.failure(ErrorParser.parse(error, stackTrace));
  }
}
