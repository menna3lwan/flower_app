import 'package:equatable/equatable.dart';
import '../../../../../../core/base/operation_state.dart';
import '../../../../domain/entities/product_details_entity.dart';

class ProductDetailsState extends Equatable {
  final OperationState<ProductDetailsEntity> operationState;

  const ProductDetailsState({required this.operationState});

  ProductDetailsState copyWith({OperationState<ProductDetailsEntity>? operationState}) {
    return ProductDetailsState(operationState: operationState ?? this.operationState);
  }

  @override
  List<Object?> get props => [operationState];
}