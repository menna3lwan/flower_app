import 'package:equatable/equatable.dart';

class IncludesEntity extends Equatable {
  final String? name;
  final int? quantity;

  const IncludesEntity({
    this.name,
    this.quantity,
  });

  @override
  List<Object?> get props => [name, quantity];
}