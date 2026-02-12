import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import '../repositories/doctor_repository.dart';
import '../entities/doctor_entity.dart';

class GetDoctorsUseCase {
  final DoctorRepository _repository;

  GetDoctorsUseCase(this._repository);

  Future<Either<Failure, List<DoctorEntity>>> call({String? branchId}) async {
    return await _repository.getDoctors(branchId: branchId);
  }
}
