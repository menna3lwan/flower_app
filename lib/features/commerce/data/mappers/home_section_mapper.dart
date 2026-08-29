import '../../domain/entities/home_section_entity.dart';
import '../../domain/entities/home_section_type.dart';
import '../models/home_section_dto.dart';

/// DTO -> domain entity mapping for Home sections, kept separate from `commerce_mapper.dart` (catalog content), which is out of this task's scope.
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
