import 'package:equatable/equatable.dart';
import 'product_details_entity.dart';

class ProductDetailsResponseEntity extends Equatable {
  final bool status;
  final ProductDetailsEntity? data;
  final List<dynamic>? errors;
  final int? code;
  final String message;

  const ProductDetailsResponseEntity({
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