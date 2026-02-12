import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';

enum EditDoctorStatus { initial, loading, success, failure }

class EditDoctorState extends Equatable {
  final EditDoctorStatus status;
  final String? errorMessage;
  final bool isLoadingData;

  final String id;
  final String fullName;
  final String title;
  final String specialty;
  final String imageUrl;
  final String biography;
  final String experience;
  final String patients;
  final String reviews;
  final String diplomaNo;
  final String email;
  final String nationalId;
  final String phoneNumber;
  final String gender;

  final String? selectedBranchId;

  final List<BranchEntity> branches;

  final List<String> acceptedInsurances;
  final List<String> subSpecialties;
  final List<String> professionalExperiences;
  final List<String> educations;
  final List<Map<String, dynamic>> schedules;

  const EditDoctorState({
    this.status = EditDoctorStatus.initial,
    this.errorMessage,
    this.isLoadingData = false,
    this.id = '',
    this.fullName = '',
    this.title = '',
    this.specialty = '',
    this.imageUrl = '',
    this.biography = '',
    this.experience = '',
    this.patients = '',
    this.reviews = '',
    this.diplomaNo = '',
    this.email = '',
    this.nationalId = '',
    this.phoneNumber = '',
    this.gender = '',
    this.selectedBranchId,
    this.branches = const [],
    this.acceptedInsurances = const [],
    this.subSpecialties = const [],
    this.professionalExperiences = const [],
    this.educations = const [],
    this.schedules = const [],
  });

  EditDoctorState copyWith({
    EditDoctorStatus? status,
    String? errorMessage,
    bool? isLoadingData,
    String? id,
    String? fullName,
    String? title,
    String? specialty,
    String? imageUrl,
    String? biography,
    String? experience,
    String? patients,
    String? reviews,
    String? diplomaNo,
    String? email,
    String? nationalId,
    String? phoneNumber,
    String? gender,
    String? selectedBranchId,
    List<BranchEntity>? branches,
    List<String>? acceptedInsurances,
    List<String>? subSpecialties,
    List<String>? professionalExperiences,
    List<String>? educations,
    List<Map<String, dynamic>>? schedules,
  }) {
    return EditDoctorState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoadingData: isLoadingData ?? this.isLoadingData,
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      title: title ?? this.title,
      specialty: specialty ?? this.specialty,
      imageUrl: imageUrl ?? this.imageUrl,
      biography: biography ?? this.biography,
      experience: experience ?? this.experience,
      patients: patients ?? this.patients,
      reviews: reviews ?? this.reviews,
      diplomaNo: diplomaNo ?? this.diplomaNo,
      email: email ?? this.email,
      nationalId: nationalId ?? this.nationalId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      branches: branches ?? this.branches,
      acceptedInsurances: acceptedInsurances ?? this.acceptedInsurances,
      subSpecialties: subSpecialties ?? this.subSpecialties,
      professionalExperiences:
          professionalExperiences ?? this.professionalExperiences,
      educations: educations ?? this.educations,
      schedules: schedules ?? this.schedules,
    );
  }

  bool get isValid => fullName.isNotEmpty && title.isNotEmpty;

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    isLoadingData,
    id,
    fullName,
    title,
    specialty,
    imageUrl,
    biography,
    experience,
    patients,
    reviews,
    diplomaNo,
    email,
    nationalId,
    phoneNumber,
    gender,
    selectedBranchId,
    branches,
    acceptedInsurances,
    subSpecialties,
    professionalExperiences,
    educations,
    schedules,
  ];
}
