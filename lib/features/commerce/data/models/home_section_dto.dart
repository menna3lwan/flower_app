/// Raw wire shape of the backend's `HomeSection`, parsed with manual `fromJson` (matches this codebase's no-codegen DTO convention).
class HomeSectionDto {
  const HomeSectionDto({
    required this.id,
    required this.type,
    required this.index,
    required this.isActive,
    this.title,
    this.occasionId,
    this.categoryId,
  });

  factory HomeSectionDto.fromJson(Map<String, dynamic> json) {
    return HomeSectionDto(
      id: json['id'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      index: json['index'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? false,
      title: json['title'] as String?,
      occasionId: json['occasionId'] as int?,
      categoryId: json['categoryId'] as int?,
    );
  }

  final int id;
  final String type;
  final int index;
  final bool isActive;
  final String? title;
  final int? occasionId;
  final int? categoryId;
}
