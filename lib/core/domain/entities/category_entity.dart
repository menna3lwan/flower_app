import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconName,
  });

  final String id;
  final String name;

  /// Name of a [Material Icons] identifier resolved by the presentation
  /// layer — kept as a string so the domain layer has zero Flutter
  /// dependency.
  final String iconName;

  @override
  List<Object?> get props => [id, name, iconName];
}
