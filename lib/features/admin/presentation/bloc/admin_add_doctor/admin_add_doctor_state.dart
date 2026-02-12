import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';

import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';

enum AddDoctorStatus { initial, loading, success, failure }

class AddDoctorState extends Equatable {
  final AddDoctorStatus status;
  final Failure? failure;

  final List<BranchEntity> branches;
  final bool isLoadingBranches;

  final String fullName;
  final String password;
  final String nationalId;
  final String email;
  final String phoneNumber;
  final String biography;
  final String imageUrl;
  final String title;
  final String diplomaNo;
  final String experience;
  final String initialPatients;
  final String gender;
  final String specialty;
  final String? selectedBranchId;
  final List<String> acceptedInsurances;
  final List<String> subSpecialties;
  final List<String> professionalExperiences;
  final List<String> educations;
  final List<Map<String, dynamic>> schedules;

  const AddDoctorState({
    this.status = AddDoctorStatus.initial,
    this.failure,
    this.branches = const [],
    this.isLoadingBranches = false,
    this.fullName = '',
    this.password = '',
    this.nationalId = '',
    this.email = '',
    this.phoneNumber = '',
    this.biography = '',
    this.imageUrl = '',
    this.title = '',
    this.diplomaNo = '',
    this.experience = '',
    this.initialPatients = '',
    this.gender = 'Male',
    this.specialty = '',
    this.selectedBranchId,
    this.acceptedInsurances = const [],
    this.subSpecialties = const [],
    this.professionalExperiences = const [],
    this.educations = const [],
    this.schedules = const [],
  });

  bool get isValid =>
      fullName.isNotEmpty &&
      password.isNotEmpty &&
      email.isNotEmpty &&
      selectedBranchId != null;

  AddDoctorState copyWith({
    AddDoctorStatus? status,
    Failure? failure,
    List<BranchEntity>? branches,
    bool? isLoadingBranches,
    String? fullName,
    String? password,
    String? nationalId,
    String? email,
    String? phoneNumber,
    String? biography,
    String? imageUrl,
    String? title,
    String? diplomaNo,
    String? experience,
    String? initialPatients,
    String? gender,
    String? specialty,
    String? selectedBranchId,
    List<String>? acceptedInsurances,
    List<String>? subSpecialties,
    List<String>? professionalExperiences,
    List<String>? educations,
    List<Map<String, dynamic>>? schedules,
  }) {
    return AddDoctorState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      branches: branches ?? this.branches,
      isLoadingBranches: isLoadingBranches ?? this.isLoadingBranches,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      nationalId: nationalId ?? this.nationalId,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      biography: biography ?? this.biography,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      diplomaNo: diplomaNo ?? this.diplomaNo,
      experience: experience ?? this.experience,
      initialPatients: initialPatients ?? this.initialPatients,
      gender: gender ?? this.gender,
      specialty: specialty ?? this.specialty,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      acceptedInsurances: acceptedInsurances ?? this.acceptedInsurances,
      subSpecialties: subSpecialties ?? this.subSpecialties,
      professionalExperiences:
          professionalExperiences ?? this.professionalExperiences,
      educations: educations ?? this.educations,
      schedules: schedules ?? this.schedules,
    );
  }

  @override
  List<Object?> get props => [
    status,
    failure,
    branches,
    isLoadingBranches,
    fullName,
    password,
    nationalId,
    email,
    phoneNumber,
    biography,
    imageUrl,
    title,
    diplomaNo,
    experience,
    initialPatients,
    gender,
    specialty,
    selectedBranchId,
    acceptedInsurances,
    subSpecialties,
    professionalExperiences,
    educations,
    schedules,
  ];
}
