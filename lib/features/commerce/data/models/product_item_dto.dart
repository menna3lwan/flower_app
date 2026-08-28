import 'package:json_annotation/json_annotation.dart';
part 'product_item_dto.g.dart';

@JsonSerializable()
class ProductItemDTO {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;
  @JsonKey(name: "originalPrice")
  final double? originalPrice;
  @JsonKey(name: "discountedPrice")
  final double? discountedPrice;
  @JsonKey(name: "discountPercentage")
  final int? discountPercentage;
  @JsonKey(name: "isOutOfStock")
  final bool? isOutOfStock;

  ProductItemDTO ({
    this.id,
    this.name,
    this.imageUrl,
    this.originalPrice,
    this.discountedPrice,
    this.discountPercentage,
    this.isOutOfStock,
  });

  factory ProductItemDTO.fromJson(Map<String, dynamic> json) {
    return _$ProductItemDTOFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ProductItemDTOToJson(this);
  }
}
