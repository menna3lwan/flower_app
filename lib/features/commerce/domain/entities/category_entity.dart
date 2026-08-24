import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconName,
  });

  final String id;
  final String name;

  /// Material Icon identifier as a string, keeping the domain layer free of Flutter dependencies.
  final String iconName;

  @override
  List<Object?> get props => [id, name, iconName];
}
