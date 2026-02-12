import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_schedule_entity.dart';

class DoctorEntity extends Equatable {
  final int id;
  final String fullName;
  final String specialty;
  final String imageUrl;
  final String title;
  final String type;
  final List<ScheduleEntity> schedules;
  final String branchName;
  final int? branchId;
  final String biography;
  final double rating;
  final int reviewCount;
  final int patientCount;
  final int experience;
  final double consultationFee;
  final List<String> subSpecialties;
  final List<String> professionalExperiences;
  final List<String> educations;
  final List<String> certificates;
  final List<String> languages;
  final List<String> acceptedInsurances;

  const DoctorEntity({
    required this.id,
    required this.fullName,
    required this.specialty,
    required this.imageUrl,
    required this.title,
    this.type = 'General',
    this.schedules = const [],
    this.branchName = '',
    this.branchId,
    this.biography = '',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.patientCount = 0,
    this.experience = 0,
    this.consultationFee = 0.0,
    this.subSpecialties = const [],
    this.professionalExperiences = const [],
    this.educations = const [],
    this.certificates = const [],
    this.languages = const [],
    this.acceptedInsurances = const [],
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    specialty,
    title,
    branchId,
    rating,
    reviewCount,
    experience,
  ];
}
