import 'package:customer_app/features/commerce/data/models/products_data_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'products_response.g.dart';

@JsonSerializable()
class ProductsResponse {
  @JsonKey(name: "status")
  final bool? status;
  @JsonKey(name: "data")
  final ProductsDataDTO? data;
  @JsonKey(name: "errors")
  final List<String>? errors;
  @JsonKey(name: "code")
  final int? code;
  @JsonKey(name: "message")
  final String? message;

  ProductsResponse ({
    this.status,
    this.data,
    this.errors,
    this.code,
    this.message,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return _$ProductsResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ProductsResponseToJson(this);
  }
}