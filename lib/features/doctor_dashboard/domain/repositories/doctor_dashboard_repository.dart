import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/entities/my_profile_entity.dart';

abstract class DoctorDashboardRepository {
  Future<Either<Failure, MyProfileEntity>> getMyProfile();

  Future<Either<Failure, void>> updateProfile({
    required String biography,
    required int experience,
    required List<WorkSchedule> schedules,
    required List<String> subSpecialties,
    required List<String> educations,
    String? imageUrl,
  });
}
