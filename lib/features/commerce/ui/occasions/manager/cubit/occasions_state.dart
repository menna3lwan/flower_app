import 'package:equatable/equatable.dart';

import '../../../../../../core/base/operation_state.dart';
import '../../../../../../core/base/pagination_state.dart';
import '../../../../domain/entities/occasion_entity.dart';
import '../../../../domain/entities/product_item_entity.dart';

class OccasionsState extends Equatable {
  final PaginationState<ProductItemEntity> productsByOccasionIdState;
  final OperationState<List<OccasionEntity>> occasionsState;

  const OccasionsState({
    required this.productsByOccasionIdState,
    required this.occasionsState,
  });

  OccasionsState copyWith({
    PaginationState<ProductItemEntity>? productsByOccasionIdState,
    OperationState<List<OccasionEntity>>? occasionsState,
  }) {
    return OccasionsState(
      productsByOccasionIdState:
      productsByOccasionIdState ?? this.productsByOccasionIdState,
      occasionsState: occasionsState ?? this.occasionsState,
    );
  }

  @override
  List<Object?> get props => [productsByOccasionIdState, occasionsState];
}
