import 'package:customer_app/features/commerce/data/models/product_item_dto.dart';
import 'package:json_annotation/json_annotation.dart';
part 'products_data_dto.g.dart';

@JsonSerializable()
class ProductsDataDTO {
  @JsonKey(name: "items")
  final List<ProductItemDTO>? items;
  @JsonKey(name: "pageNumber")
  final int? pageNumber;
  @JsonKey(name: "pageSize")
  final int? pageSize;
  @JsonKey(name: "totalCount")
  final int? totalCount;
  @JsonKey(name: "hasNextPage")
  final bool? hasNextPage;

  ProductsDataDTO ({
    this.items,
    this.pageNumber,
    this.pageSize,
    this.totalCount,
    this.hasNextPage,
  });

  factory ProductsDataDTO.fromJson(Map<String, dynamic> json) {
    return _$ProductsDataDTOFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ProductsDataDTOToJson(this);
  }
}

