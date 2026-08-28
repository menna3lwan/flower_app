import 'package:equatable/equatable.dart';
import 'category_entity.dart';

class CategoryResponseEntity extends Equatable {
  final bool status;
  final CategoryEntity? data;
  final List<dynamic>? errors;
  final int? code;
  final String message;

  const CategoryResponseEntity({
    required this.status,
    this.data,
    this.errors,
    this.code,
    required this.message,
  });

  @override
  List<Object?> get props => [
    status,
    data,
    errors,
    code,
    message,
  ];
}