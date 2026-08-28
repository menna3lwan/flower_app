import 'package:equatable/equatable.dart';

class PaginationParams extends Equatable {
  final int page;
  final int pageSize;

  const PaginationParams({
    this.page = 1,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [page, pageSize];
}
