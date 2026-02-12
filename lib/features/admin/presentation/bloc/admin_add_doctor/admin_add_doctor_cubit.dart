import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/admin/domain/usecases/add_doctor_usecase.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_add_doctor/admin_add_doctor_state.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/branches/domain/repositories/branch_repository.dart';

import '../../../../branches/domain/usecases/get_all_branches_usecase.dart';

class AddDoctorCubit extends Cubit<AddDoctorState> {
  final AddDoctorUseCase _addDoctorUseCase;
  final GetAllBranchesUseCase _getAllBranchesUseCase;

  static const String _defaultReviews = "0";
  static const int _defaultSpecialtyId = 0;
  static const int _defaultExperience = 0;

  AddDoctorCubit({
    required AddDoctorUseCase addDoctorUseCase,
    required GetAllBranchesUseCase getAllBranchesUseCase,
  }) : _addDoctorUseCase = addDoctorUseCase,
       _getAllBranchesUseCase = getAllBranchesUseCase,
       super(const AddDoctorState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (isClosed) return;
    emit(state.copyWith(isLoadingBranches: true));

    final result = await _getAllBranchesUseCase();
    if (isClosed) return;

    result.fold<void>(
      (failure) {
        emit(state.copyWith(isLoadingBranches: false));
      },
      (List<BranchEntity> branches) {
        emit(state.copyWith(branches: branches, isLoadingBranches: false));
      },
    );
  }

  void fullNameChanged(String val) => emit(state.copyWith(fullName: val));
  void passwordChanged(String val) => emit(state.copyWith(password: val));
  void nationalIdChanged(String val) => emit(state.copyWith(nationalId: val));
  void emailChanged(String val) => emit(state.copyWith(email: val));
  void phoneNumberChanged(String val) => emit(state.copyWith(phoneNumber: val));
  void biographyChanged(String val) => emit(state.copyWith(biography: val));
  void imageUrlChanged(String val) => emit(state.copyWith(imageUrl: val));
  void titleChanged(String val) => emit(state.copyWith(title: val));
  void diplomaNoChanged(String val) => emit(state.copyWith(diplomaNo: val));
  void experienceChanged(String val) => emit(state.copyWith(experience: val));
  void patientsChanged(String val) =>
      emit(state.copyWith(initialPatients: val));
  void genderChanged(String val) => emit(state.copyWith(gender: val));
  void specialtyChanged(String val) => emit(state.copyWith(specialty: val));

  void branchChanged(String? val) {
    if (val == null) return;
    String newSpecialty = state.specialty;
    if (state.branches.isNotEmpty) {
      try {
        final selectedBranch = state.branches.firstWhere(
          (b) => b.id.toString() == val,
        );
        newSpecialty = selectedBranch.name;
      } catch (_) {}
    }
    emit(state.copyWith(selectedBranchId: val, specialty: newSpecialty));
  }

  void insurancesChanged(List<String> list) =>
      emit(state.copyWith(acceptedInsurances: list));
  void subSpecialtiesChanged(List<String> list) =>
      emit(state.copyWith(subSpecialties: list));
  void professionalExperiencesChanged(List<String> list) =>
      emit(state.copyWith(professionalExperiences: list));
  void educationsChanged(List<String> list) =>
      emit(state.copyWith(educations: list));

  void addSchedule(Map<String, dynamic> schedule) {
    final newList = List<Map<String, dynamic>>.from(state.schedules);
    newList.add(schedule);
    emit(state.copyWith(schedules: newList));
  }

  void removeSchedule(int index) {
    final newList = List<Map<String, dynamic>>.from(state.schedules);
    newList.removeAt(index);
    emit(state.copyWith(schedules: newList));
  }

  Future<void> submitForm() async {
    if (!state.isValid) {
      emit(
        state.copyWith(
          status: AddDoctorStatus.failure,

          failure: const UnknownFailure(debugMessage: "fillAllRequiredFields"),
        ),
      );
      return;
    }

    emit(state.copyWith(status: AddDoctorStatus.loading));

    final params = AddDoctorParams(
      fullName: state.fullName,
      password: state.password,
      email: state.email,
      nationalId: state.nationalId,
      gender: state.gender,
      phoneNumber: state.phoneNumber,
      biography: state.biography,
      imageUrl: state.imageUrl,
      title: state.title,
      diplomaNo: state.diplomaNo,
      branchId: int.parse(state.selectedBranchId!),
      specialtyId: _defaultSpecialtyId,
      experience: int.tryParse(state.experience) ?? _defaultExperience,
      patients: state.initialPatients,
      reviews: _defaultReviews,
      specialty: state.specialty,
      acceptedInsurances: state.acceptedInsurances,
      subSpecialties: state.subSpecialties,
      professionalExperiences: state.professionalExperiences,
      educations: state.educations,
      schedules: state.schedules,
    );

    final result = await _addDoctorUseCase(params);

    result.fold<void>(
      (failure) => emit(
        state.copyWith(status: AddDoctorStatus.failure, failure: failure),
      ),
      (_) => emit(state.copyWith(status: AddDoctorStatus.success)),
    );
  }
}
