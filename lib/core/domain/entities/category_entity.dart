import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconName,
  });

  final String id;
  final String name;

  /// Material Icons identifier string, kept as text so the domain layer stays free of any Flutter dependency.
  final String iconName;

  @override
  List<Object?> get props => [id, name, iconName];
}
