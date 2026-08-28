import 'package:json_annotation/json_annotation.dart';

part 'occasion_dto.g.dart';

@JsonSerializable()
class OccasionDTO {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;

  OccasionDTO ({
    this.id,
    this.name,
    this.imageUrl,
  });

  factory OccasionDTO.fromJson(Map<String, dynamic> json) {
    return _$OccasionDTOFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$OccasionDTOToJson(this);
  }
}