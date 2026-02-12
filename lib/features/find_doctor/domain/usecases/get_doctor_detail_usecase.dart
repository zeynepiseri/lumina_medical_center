import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import '../repositories/doctor_repository.dart';
import '../entities/doctor_entity.dart';

class GetDoctorDetailUseCase {
  final DoctorRepository _repository;

  GetDoctorDetailUseCase(this._repository);

  Future<Either<Failure, DoctorEntity>> call(int id) async {
    return await _repository.getDoctorById(id);
  }
}
