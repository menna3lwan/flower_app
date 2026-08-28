import 'package:equatable/equatable.dart';

import 'occasion_entity.dart';

class OccasionsResponseEntity extends Equatable {
  final bool status;
  final List<OccasionEntity>? data;
  final List<String>? errors;
  final int? code;
  final String message;

  const OccasionsResponseEntity({
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