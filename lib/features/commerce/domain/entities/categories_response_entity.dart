import 'package:equatable/equatable.dart';
import 'category_entity.dart';

class CategoriesResponseEntity extends Equatable {
  final bool status;
  final List<CategoryEntity>? data;
  final List<dynamic>? errors;
  final int? code;
  final String message;

  const CategoriesResponseEntity({
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