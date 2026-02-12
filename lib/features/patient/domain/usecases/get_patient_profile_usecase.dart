import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import '../entities/patient_entity.dart';
import '../repositories/patient_repository.dart';

class GetPatientProfileUseCase {
  final PatientRepository repository;

  GetPatientProfileUseCase(this.repository);

  Future<Either<Failure, PatientEntity>> call() async {
    return await repository.getPatientProfile();
  }
}
