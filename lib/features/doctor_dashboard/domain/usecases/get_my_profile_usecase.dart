import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/entities/my_profile_entity.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/repositories/doctor_dashboard_repository.dart';

class GetMyProfileUseCase {
  final DoctorDashboardRepository _repository;

  GetMyProfileUseCase(this._repository);

  Future<Either<Failure, MyProfileEntity>> call() async {
    return await _repository.getMyProfile();
  }
}
