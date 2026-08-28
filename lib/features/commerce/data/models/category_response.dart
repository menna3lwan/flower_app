import 'package:json_annotation/json_annotation.dart';

import 'category_dto.dart';

part 'category_response.g.dart';

@JsonSerializable()
class CategoryResponse {
  @JsonKey(name: "status")
  final bool? status;
  @JsonKey(name: "data")
  final CategoryDTO? data;
  @JsonKey(name: "errors")
  final List<dynamic>? errors;
  @JsonKey(name: "code")
  final int? code;
  @JsonKey(name: "message")
  final String? message;

  CategoryResponse ({
    this.status,
    this.data,
    this.errors,
    this.code,
    this.message,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return _$CategoryResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CategoryResponseToJson(this);
  }
}