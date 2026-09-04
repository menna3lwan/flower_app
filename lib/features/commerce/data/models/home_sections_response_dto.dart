import 'home_section_dto.dart';

/// Unwraps the backend's `OperationResult` envelope for `GET /home/sections`; one malformed entry is dropped, not the whole response.
class HomeSectionsResponseDto {
  const HomeSectionsResponseDto({
    required this.isSuccess,
    required this.sections,
  });

  factory HomeSectionsResponseDto.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    final sections = <HomeSectionDto>[];
    if (rawList is List) {
      for (final item in rawList) {
        if (item is! Map<String, dynamic>) continue;
        try {
          sections.add(HomeSectionDto.fromJson(item));
        } catch (_) {
          continue;
        }
      }
    }
    return HomeSectionsResponseDto(
      isSuccess: json['isSuccess'] as bool? ?? false,
      sections: sections,
    );
  }

  final bool isSuccess;
  final List<HomeSectionDto> sections;
}
