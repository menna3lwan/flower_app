import 'package:equatable/equatable.dart';
import 'product_item_entity.dart';
import 'pagination_entity.dart';

class ProductsDataEntity extends Equatable {
  final List<ProductItemEntity>? items;
  final PaginationEntity? pagination;

  const ProductsDataEntity({
    this.items,
    this.pagination,
  });

  @override
  List<Object?> get props => [items, pagination];
}