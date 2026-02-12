import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import '../repositories/admin_repository.dart';

class UpdateDoctorUseCase {
  final AdminRepository _repository;

  UpdateDoctorUseCase(this._repository);

  Future<Either<Failure, void>> call(UpdateDoctorParams params) async {
    return await _repository.updateDoctor(params);
  }
}

class UpdateDoctorParams extends Equatable {
  final int id;
  final String fullName;
  final String title;
  final String specialty;
  final String imageUrl;
  final String biography;
  final int branchId;
  final int experience;
  final String patients;
  final String reviews;
  final String email;
  final String nationalId;
  final String phoneNumber;
  final String gender;
  final String diplomaNo;
  final List<String> acceptedInsurances;
  final List<String> subSpecialties;
  final List<String> professionalExperiences;
  final List<String> educations;
  final List<Map<String, dynamic>> schedules;

  const UpdateDoctorParams({
    required this.id,
    required this.fullName,
    required this.title,
    required this.specialty,
    required this.imageUrl,
    required this.biography,
    required this.branchId,
    required this.experience,
    required this.patients,
    required this.reviews,
    required this.email,
    required this.nationalId,
    required this.phoneNumber,
    required this.gender,
    required this.diplomaNo,
    required this.acceptedInsurances,
    required this.subSpecialties,
    required this.professionalExperiences,
    required this.educations,
    required this.schedules,
  });

  @override
  List<Object?> get props => [id, fullName, branchId, nationalId, email];
}
