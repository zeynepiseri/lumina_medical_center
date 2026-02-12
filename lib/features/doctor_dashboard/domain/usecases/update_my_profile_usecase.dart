import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/entities/my_profile_entity.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/repositories/doctor_dashboard_repository.dart';

class UpdateMyProfileUseCase {
  final DoctorDashboardRepository _repository;

  UpdateMyProfileUseCase(this._repository);

  Future<Either<Failure, void>> call(UpdateProfileParams params) async {
    return await _repository.updateProfile(
      biography: params.biography,
      experience: params.experience,
      schedules: params.schedules,
      subSpecialties: params.subSpecialties,
      educations: params.educations,
      imageUrl: params.imageUrl,
    );
  }
}

class UpdateProfileParams {
  final String biography;
  final int experience;
  final List<WorkSchedule> schedules;
  final List<String> subSpecialties;
  final List<String> educations;
  final String? imageUrl;

  const UpdateProfileParams({
    required this.biography,
    required this.experience,
    required this.schedules,
    required this.subSpecialties,
    required this.educations,
    this.imageUrl,
  });
}
