import '../../domain/entities/home_section_entity.dart';
import '../../domain/entities/home_section_type.dart';
import '../models/home_section_dto.dart';

/// DTO → domain mapping for Home sections.
extension HomeSectionDtoMapper on HomeSectionDto {
  HomeSectionEntity toEntity() {
    return HomeSectionEntity(
      id: id.toString(),
      type: type.toHomeSectionType(),
      order: index,
      isActive: isActive,
      title: title,
      occasionId: occasionId?.toString(),
      categoryId: categoryId?.toString(),
    );
  }
}
