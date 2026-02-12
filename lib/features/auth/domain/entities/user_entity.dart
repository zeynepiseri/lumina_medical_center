import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? nationalId;
  final String? imageUrl;
  final String? gender;
  final String? birthDate;
  final String role;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.nationalId,
    this.imageUrl,
    this.gender,
    this.birthDate,
    required this.role,
  });

  @override
  List<Object?> get props => [id, fullName, email, role, imageUrl, phoneNumber];
}
