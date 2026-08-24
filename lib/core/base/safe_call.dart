import '../network/error_parser.dart';
import '../result/result.dart';

/// Central place a throwing data-layer call becomes a [Result] via [ErrorParser], instead of each repository writing its own try/catch.
Future<Result<T>> safeCall<T>(Future<T> Function() operation) async {
  try {
    final data = await operation();
    return Result.success(data);
  } catch (error, stackTrace) {
    return Result.failure(ErrorParser.parse(error, stackTrace));
  }
}
