import 'package:equatable/equatable.dart';

import '../../../../../../core/base/operation_state.dart';
import '../../../../../../core/base/pagination_state.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../../domain/entities/product_item_entity.dart';

class CategoriesState extends Equatable {
  final PaginationState<ProductItemEntity> productsByCategoryIdState;
  final OperationState<List<CategoryEntity>> categoriesState;

  const CategoriesState({
    required this.productsByCategoryIdState,
    required this.categoriesState,
  });

  CategoriesState copyWith({
    PaginationState<ProductItemEntity>? productsByCategoryIdState,
    OperationState<List<CategoryEntity>>? categoriesState,
  }) {
    return CategoriesState(
      productsByCategoryIdState:
          productsByCategoryIdState ?? this.productsByCategoryIdState,
      categoriesState: categoriesState ?? this.categoriesState,
    );
  }

  @override
  List<Object?> get props => [productsByCategoryIdState, categoriesState];
}
