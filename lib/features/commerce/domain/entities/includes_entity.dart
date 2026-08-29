import 'package:equatable/equatable.dart';

class IncludesEntity extends Equatable {
  final String? name;

  const IncludesEntity({
    this.name,
  });

  @override
  List<Object?> get props => [name];
}