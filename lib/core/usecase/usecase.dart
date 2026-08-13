import '../result/result.dart';

/// Contract every domain use case implements.
///
/// [Type] is the successful return type, [Params] the input. Use cases
/// with no parameters should take [NoParams]. Keeping use cases as thin,
/// single-method callables (rather than fat "manager" classes) is what
/// lets a Cubit orchestrate a feature without knowing anything about how
/// the result was produced.
abstract interface class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

/// Marker type for use cases that don't need input parameters.
final class NoParams {
  const NoParams();
}
