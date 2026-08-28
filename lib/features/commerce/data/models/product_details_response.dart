import 'package:customer_app/features/commerce/data/models/product_details_data_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_details_response.g.dart';

@JsonSerializable()
class ProductDetailsResponse {
  @JsonKey(name: 'status')
  final bool? status;

  @JsonKey(name: 'data')
  final ProductDetailsDataDTO? data;

  @JsonKey(name: 'errors')
  final List<String>? errors;

  @JsonKey(name: 'code')
  final int? code;

  @JsonKey(name: 'message')
  final String? message;

  const ProductDetailsResponse({
    this.status,
    this.data,
    this.errors,
    this.code,
    this.message,
  });

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) {
    return _$ProductDetailsResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ProductDetailsResponseToJson(this);
  }
}