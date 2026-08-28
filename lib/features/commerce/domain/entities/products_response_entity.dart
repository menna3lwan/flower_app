import 'package:equatable/equatable.dart';
import 'products_data_entity.dart';

class ProductsResponseEntity extends Equatable {
  final bool status;
  final ProductsDataEntity? data;
  final List<dynamic>? errors;
  final int? code;
  final String message;

  const ProductsResponseEntity({
    required this.status,
    this.data,
    this.errors,
    this.code,
    required this.message,
  });

  @override
  List<Object?> get props => [status, data, errors, code, message];
}
