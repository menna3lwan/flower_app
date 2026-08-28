import 'package:equatable/equatable.dart';
import '../../../../../../core/base/pagination_state.dart';
import '../../../../domain/entities/product_item_entity.dart';

class BestSellerState extends Equatable {
  final PaginationState<ProductItemEntity> operationState;

  const BestSellerState({required this.operationState});

  BestSellerState copyWith({PaginationState<ProductItemEntity>? operationState}) {
    return BestSellerState(operationState: operationState ?? this.operationState);
  }

  @override
  List<Object?> get props => [operationState];
}