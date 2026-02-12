import 'package:equatable/equatable.dart';

class PatientEntity extends Equatable {
  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? nationalId;
  final String? imageUrl;
  final String? gender;
  final DateTime? birthDate;
  final double? height;
  final double? weight;
  final String? bloodType;
  final List<String> allergies;
  final List<String> chronicDiseases;

  const PatientEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.nationalId,
    this.imageUrl,
    this.gender,
    this.birthDate,
    this.height,
    this.weight,
    this.bloodType,
    this.allergies = const [],
    this.chronicDiseases = const [],
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phoneNumber,
    nationalId,
    imageUrl,
    gender,
    birthDate,
    height,
    weight,
    bloodType,
    allergies,
    chronicDiseases,
  ];
}
