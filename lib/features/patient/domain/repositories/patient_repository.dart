import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/patient_entity.dart';

abstract class PatientRepository {
  Future<Either<Failure, PatientEntity>> getPatientProfile();

  Future<Either<Failure, void>> updatePatientVitals({
    double? height,
    double? weight,
    String? bloodType,
  });
}
