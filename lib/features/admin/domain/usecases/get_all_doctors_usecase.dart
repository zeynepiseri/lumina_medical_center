import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';
import 'package:lumina_medical_center/features/admin/domain/repositories/admin_repository.dart';

class GetAllDoctorsUseCase {
  final AdminRepository _repository;

  GetAllDoctorsUseCase(this._repository);

  Future<Either<Failure, List<AdminDoctorEntity>>> call() async {
    return await _repository.getAllDoctors();
  }
}
