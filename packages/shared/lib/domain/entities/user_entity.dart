import 'package:equatable/equatable.dart';

enum Gender { female, male }

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
