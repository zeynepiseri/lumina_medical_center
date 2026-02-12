import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/repositories/patient_repository.dart';
import '../datasources/patient_remote_datasource.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remoteDataSource;

  PatientRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PatientEntity>> getPatientProfile() async {
    try {
      final patient = await remoteDataSource.getCurrentPatient();
      return Right(patient);
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePatientVitals({
    double? height,
    double? weight,
    String? bloodType,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (height != null) updates['height'] = height;
      if (weight != null) updates['weight'] = weight;
      if (bloodType != null) updates['bloodType'] = bloodType;

      await remoteDataSource.updateVitals(updates);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }
}
