import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/repositories/doctor_repository.dart';

class GetTopDoctorsUseCase {
  final DoctorRepository repository;

  GetTopDoctorsUseCase(this.repository);

  Future<Either<Failure, List<DoctorEntity>>> call() async {
    return await repository.getDoctors();
  }
}
