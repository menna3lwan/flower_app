import 'package:equatable/equatable.dart';

enum AddressLabel { home, office, other }

class AddressEntity extends Equatable {
  const AddressEntity({
    required this.id,
    required this.label,
    required this.city,
    required this.details,
    this.recipientName,
    this.phoneNumber,
    this.area,
    this.isDefault = false,
  });

  final String id;
  final AddressLabel label;
  final String city;

  /// Free-form street/building detail line, e.g. "2XVP+XC - Sheikh Zayed".
  final String details;
  final String? recipientName;
  final String? phoneNumber;
  final String? area;
  final bool isDefault;

  @override
  List<Object?> get props => [
        id,
        label,
        city,
        details,
        recipientName,
        phoneNumber,
        area,
        isDefault,
      ];
}
