import 'package:json_annotation/json_annotation.dart';
import 'category_dto.dart';

part 'categories_response.g.dart';

@JsonSerializable()
class CategoriesResponse {
  @JsonKey(name: "status")
  final bool? status;
  @JsonKey(name: "data")
  final List<CategoryDTO>? data;
  @JsonKey(name: "errors")
  final List<dynamic>? errors;
  @JsonKey(name: "code")
  final int? code;
  @JsonKey(name: "message")
  final String? message;

  CategoriesResponse ({
    this.status,
    this.data,
    this.errors,
    this.code,
    this.message,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return _$CategoriesResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CategoriesResponseToJson(this);
  }
}