import 'package:equatable/equatable.dart';

enum Gender { female, male }

/// Maps [Gender] to/from the backend's wire representation.
///
/// CONFIRMED backend contract (`CustomerRegisterCommand.gender` in the
/// live Auth service's Swagger): the field is a required, non-nullable
/// integer enum with exactly two valid values, `1` and `2`. The Swagger
/// document does not carry the C# enum member names (Swashbuckle only
/// emits the integers), and no endpoint echoes gender back in a way that
/// would let this be verified empirically (login doesn't return it,
/// there is no "get my profile" endpoint, and the JWT carries no gender
/// claim — all checked against the running backend).
///
/// UNCONFIRMED: which integer is Male and which is Female.
/// `male -> 1, female -> 2` below is this codebase's working assumption
/// pending explicit confirmation from the Backend team — see
/// docs/BACKEND_INTEGRATION_TODO.md. If this is backwards, registered
/// accounts will have the opposite gender stored than the user selected;
/// it does not otherwise break Sign Up/Login (the backend accepts both
/// values), so it was not treated as a blocker for the rest of the
/// integration.
extension GenderApiMapping on Gender {
  int get apiValue => switch (this) {
        Gender.male => 1,
        Gender.female => 2,
      };
}


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
