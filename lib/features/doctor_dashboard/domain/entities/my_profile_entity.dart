import 'package:equatable/equatable.dart';

class MyProfileEntity extends Equatable {
  final int id;
  final String fullName;
  final String title;
  final String branchName;
  final String biography;
  final int experience;
  final String diplomaNo;
  final String? email;
  final String? phoneNumber;
  final String? nationalId;
  final String imageUrl;
  final List<WorkSchedule> schedules;
  final List<String> subSpecialties;
  final List<String> educations;
  final int patientCount;

  const MyProfileEntity({
    required this.id,
    required this.fullName,
    required this.title,
    required this.branchName,
    required this.biography,
    required this.experience,
    required this.diplomaNo,
    this.email,
    this.phoneNumber,
    this.nationalId,
    required this.imageUrl,
    required this.schedules,
    required this.subSpecialties,
    required this.educations,
    required this.patientCount,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    nationalId,
    diplomaNo,
    schedules,
    experience,
    biography,
  ];
}

class WorkSchedule extends Equatable {
  final String dayOfWeek;
  final String startTime;
  final String endTime;

  const WorkSchedule({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [dayOfWeek, startTime, endTime];
}
