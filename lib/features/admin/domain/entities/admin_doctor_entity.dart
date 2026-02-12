import 'package:equatable/equatable.dart';

class AdminDoctorEntity extends Equatable {
  final int id;
  final String fullName;
  final String title;
  final String specialty;
  final String imageUrl;
  final String biography;
  final int experience;
  final int patientCount;
  final double rating;
  final int reviewCount;
  final String branchName;
  final int? branchId;

  final String email;
  final String phoneNumber;
  final String nationalId;
  final String gender;
  final String diplomaNo;
  final String birthDate;

  final List<String> subSpecialties;
  final List<String> professionalExperiences;
  final List<String> educations;
  final List<String> acceptedInsurances;
  final List<AdminWorkSchedule> schedules;

  const AdminDoctorEntity({
    required this.id,
    required this.fullName,
    required this.title,
    required this.specialty,
    required this.imageUrl,
    required this.biography,
    required this.experience,
    required this.patientCount,
    required this.rating,
    required this.reviewCount,
    this.branchName = '',
    this.branchId,
    required this.email,
    required this.phoneNumber,
    required this.nationalId,
    required this.gender,
    required this.diplomaNo,
    required this.birthDate,
    required this.subSpecialties,
    required this.professionalExperiences,
    required this.educations,
    required this.acceptedInsurances,
    required this.schedules,
  });

  @override
  List<Object?> get props => [id, fullName, nationalId, email];
}

class AdminWorkSchedule extends Equatable {
  final int? id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;

  const AdminWorkSchedule({
    this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [id, dayOfWeek, startTime, endTime];
}
