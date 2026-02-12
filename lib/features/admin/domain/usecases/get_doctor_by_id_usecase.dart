import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';
import 'package:lumina_medical_center/features/admin/domain/repositories/admin_repository.dart';

class GetDoctorByIdUseCase {
  final AdminRepository _repository;

  GetDoctorByIdUseCase(this._repository);

  Future<Either<Failure, AdminDoctorEntity>> call(int id) async {
    return await _repository.getDoctorById(id);
  }
}
