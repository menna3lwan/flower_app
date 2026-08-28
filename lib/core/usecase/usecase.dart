import '../base/pagination_params.dart';
import '../result/result.dart';
import 'package:equatable/equatable.dart';

/// Contract every domain use case implements as a thin, single-method callable rather than a fat "manager" class.
abstract interface class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Marker type for use cases that don't need input parameters.
final class NoParams {
  const NoParams();
}

final class ParamsWithPagination<T> extends Equatable {
  final T? param;
  final PaginationParams pagination;

  const ParamsWithPagination({
    this.param,
    required this.pagination,
  });

  @override
  List<Object?> get props => [param, pagination];
}
