import '../result/result.dart';

/// Contract every domain use case implements as a thin, single-method callable rather than a fat "manager".
abstract interface class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

/// Marker type for use cases that don't need input parameters.
final class NoParams {
  const NoParams();
}
