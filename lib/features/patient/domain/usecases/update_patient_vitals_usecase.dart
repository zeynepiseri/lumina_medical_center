import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import '../repositories/patient_repository.dart';

class UpdatePatientVitalsUseCase {
  final PatientRepository repository;

  UpdatePatientVitalsUseCase(this.repository);

  Future<Either<Failure, void>> call(UpdatePatientVitalsParams params) async {
    return await repository.updatePatientVitals(
      height: params.height,
      weight: params.weight,
      bloodType: params.bloodType,
    );
  }
}

class UpdatePatientVitalsParams extends Equatable {
  final double? height;
  final double? weight;
  final String? bloodType;

  const UpdatePatientVitalsParams({this.height, this.weight, this.bloodType});

  @override
  List<Object?> get props => [height, weight, bloodType];
}
