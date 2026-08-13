import 'package:equatable/equatable.dart';

enum AddressLabel { home, office, other }

/// A saved delivery/pickup address. Not consumed by any feature yet
/// (Checkout and Profile — the two features that will need it — aren't
/// built), kept here ahead of them the same way [CartItemEntity] and
/// [OrderEntity] were, rather than invented from scratch once those
/// features start.
///
/// Previously lived in a separate `shared` package (shared with the
/// Rider app, which also reads/display addresses). With the Rider app
/// removed, this package had a single dependent, so it moved in-app.
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
