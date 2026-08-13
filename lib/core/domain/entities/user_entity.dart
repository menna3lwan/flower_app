import 'package:equatable/equatable.dart';

enum Gender { female, male }

/// The authenticated (or guest) user's identity — produced by the Auth
/// feature's login/sign-up flow, but kept in `core/domain/entities`
/// rather than nested under `features/auth/` because it's the kind of
/// cross-feature identity object other features will need to read later
/// (Profile, Checkout's "who is this order for") without depending on
/// the Auth feature's internals — the same reasoning already applied to
/// [ProductEntity]/[OrderEntity] living here instead of under Catalog.
///
/// Previously lived in a separate `shared` package (shared with the
/// Rider app). With the Rider app removed, there is only one consumer
/// left, so it moved in-app instead of staying split across a package
/// with a single dependent.
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.avatarUrl,
    this.gender = Gender.female,
    this.isGuest = false,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String? avatarUrl;
  final Gender gender;
  final bool isGuest;

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phoneNumber,
        avatarUrl,
        gender,
        isGuest,
      ];
}
