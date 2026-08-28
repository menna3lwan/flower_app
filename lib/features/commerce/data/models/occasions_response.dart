import 'package:json_annotation/json_annotation.dart';
import 'occasion_dto.dart';

part 'occasions_response.g.dart';

@JsonSerializable()
class OccasionsResponse {
  @JsonKey(name: "status")
  final bool? status;
  @JsonKey(name: "data")
  final List<OccasionDTO>? data;
  @JsonKey(name: "errors")
  final List<String>? errors;
  @JsonKey(name: "code")
  final int? code;
  @JsonKey(name: "message")
  final String? message;

  OccasionsResponse ({
    this.status,
    this.data,
    this.errors,
    this.code,
    this.message,
  });

  factory OccasionsResponse.fromJson(Map<String, dynamic> json) {
    return _$OccasionsResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$OccasionsResponseToJson(this);
  }
}