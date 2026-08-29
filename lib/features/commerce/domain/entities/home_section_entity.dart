import 'package:equatable/equatable.dart';

import 'home_section_type.dart';

/// Server-driven Home layout config for one section — the "which block, in what order, filtered by what" contract, before its content is fetched.
class HomeSectionEntity extends Equatable {
  const HomeSectionEntity({
    required this.id,
    required this.type,
    required this.order,
    required this.isActive,
    this.title,
    this.occasionId,
    this.categoryId,
  });

  final String id;
  final HomeSectionType type;
  final int order;
  final bool isActive;
  final String? title;
  final String? occasionId;
  final String? categoryId;

  @override
  List<Object?> get props =>
      [id, type, order, isActive, title, occasionId, categoryId];
}
