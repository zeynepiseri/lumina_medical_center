import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/entities/my_profile_entity.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String biography;
  final int experience;
  final List<WorkSchedule> schedules;
  final String? imageUrl;
  final List<String> subSpecialties;
  final List<String> educations;

  const UpdateProfileEvent({
    required this.biography,
    required this.experience,
    required this.schedules,
    required this.subSpecialties,
    required this.educations,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    biography,
    experience,
    schedules,
    subSpecialties,
    educations,
    imageUrl,
  ];
}
