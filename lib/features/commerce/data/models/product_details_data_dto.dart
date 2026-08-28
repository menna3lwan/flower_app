import 'package:json_annotation/json_annotation.dart';

part 'product_details_data_dto.g.dart';

@JsonSerializable()
class ProductDetailsDataDTO {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'imageUrls')
  final List<String>? imageUrls;

  @JsonKey(name: 'includes')
  final List<String>? includes;

  @JsonKey(name: 'originalPrice')
  final double? originalPrice;

  @JsonKey(name: 'discountedPrice')
  final double? discountedPrice;

  @JsonKey(name: 'discountPercentage')
  final double? discountPercentage;

  @JsonKey(name: 'isOutOfStock')
  final bool? isOutOfStock;

  @JsonKey(name: 'stockQuantity')
  final int? stockQuantity;

  const ProductDetailsDataDTO({
    this.id,
    this.name,
    this.description,
    this.imageUrls,
    this.includes,
    this.originalPrice,
    this.discountedPrice,
    this.discountPercentage,
    this.isOutOfStock,
    this.stockQuantity,
  });

  factory ProductDetailsDataDTO.fromJson(Map<String, dynamic> json) {
    return _$ProductDetailsDataDTOFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ProductDetailsDataDTOToJson(this);
  }
}