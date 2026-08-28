import 'package:json_annotation/json_annotation.dart';
part 'category_dto.g.dart';

@JsonSerializable()
class CategoryDTO {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "iconUrl")
  final String? iconUrl;

  CategoryDTO ({
    this.id,
    this.name,
    this.iconUrl,
  });

  factory CategoryDTO.fromJson(Map<String, dynamic> json) {
    return _$CategoryDTOFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CategoryDTOToJson(this);
  }
}