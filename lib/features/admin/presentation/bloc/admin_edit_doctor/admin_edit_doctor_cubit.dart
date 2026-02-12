import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';
import 'package:lumina_medical_center/features/admin/domain/usecases/get_doctor_by_id_usecase.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_edit_doctor/admin_edit_doctor_state.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/branches/domain/usecases/get_all_branches_usecase.dart';
import 'package:lumina_medical_center/features/admin/domain/usecases/update_doctor_usecase.dart';

class EditDoctorCubit extends Cubit<EditDoctorState> {
  final GetDoctorByIdUseCase _getDoctorByIdUseCase;
  final GetAllBranchesUseCase _getAllBranchesUseCase;
  final UpdateDoctorUseCase _updateDoctorUseCase;

  EditDoctorCubit({
    required GetDoctorByIdUseCase getDoctorByIdUseCase,
    required GetAllBranchesUseCase getAllBranchesUseCase,
    required UpdateDoctorUseCase updateDoctorUseCase,
  }) : _getDoctorByIdUseCase = getDoctorByIdUseCase,
       _getAllBranchesUseCase = getAllBranchesUseCase,
       _updateDoctorUseCase = updateDoctorUseCase,
       super(const EditDoctorState());

  Future<void> loadInitialData(
    String doctorIdStr, {
    AdminDoctorEntity? initialDoctor,
  }) async {
    if (initialDoctor != null) {
      emit(
        state.copyWith(
          id: initialDoctor.id.toString(),
          fullName: initialDoctor.fullName,
          title: initialDoctor.title,
          specialty: initialDoctor.specialty,
          imageUrl: initialDoctor.imageUrl,
          biography: initialDoctor.biography,
          experience: initialDoctor.experience.toString(),
          patients: initialDoctor.patientCount.toString(),
          reviews: initialDoctor.rating.toString(),
          email: initialDoctor.email,
          nationalId: initialDoctor.nationalId,
          phoneNumber: initialDoctor.phoneNumber,
          gender: initialDoctor.gender,
          diplomaNo: initialDoctor.diplomaNo,
          selectedBranchId: initialDoctor.branchId?.toString() ?? '',
          acceptedInsurances: List.from(initialDoctor.acceptedInsurances),
          subSpecialties: List.from(initialDoctor.subSpecialties),
          professionalExperiences: List.from(
            initialDoctor.professionalExperiences,
          ),
          educations: List.from(initialDoctor.educations),
          schedules: initialDoctor.schedules
              .map(
                (s) => {
                  'id': s.id,
                  'dayOfWeek': s.dayOfWeek,
                  'startTime': s.startTime,
                  'endTime': s.endTime,
                },
              )
              .toList(),
        ),
      );
    }

    emit(state.copyWith(isLoadingData: true));

    final int doctorId = int.tryParse(doctorIdStr) ?? 0;
    if (doctorId == 0) {
      emit(state.copyWith(isLoadingData: false, errorMessage: "invalidId"));
      return;
    }

    final results = await Future.wait([
      _getDoctorByIdUseCase(doctorId),
      _getAllBranchesUseCase(),
    ]);

    final doctorResult = results[0];
    final branchesResult = results[1];

    AdminDoctorEntity? fetchedDoctor;
    List<BranchEntity> branches = [];
    String? errorMsg;

    (doctorResult as dynamic).fold(
      (failure) => errorMsg = failure.errorMessage,
      (data) => fetchedDoctor = data as AdminDoctorEntity,
    );

    (branchesResult as dynamic).fold(
      (failure) => errorMsg ??= failure.errorMessage,
      (data) {
        if (data is List) {
          branches = List<BranchEntity>.from(data);
        }
      },
    );

    if (errorMsg != null && initialDoctor == null) {
      emit(
        state.copyWith(
          isLoadingData: false,

          errorMessage: errorMsg ?? "dataLoadFailed",
        ),
      );
      return;
    }

    if (fetchedDoctor != null) {
      emit(
        state.copyWith(
          isLoadingData: false,
          id: fetchedDoctor!.id.toString(),
          fullName: fetchedDoctor!.fullName,
          title: fetchedDoctor!.title,
          specialty: fetchedDoctor!.specialty,
          imageUrl: fetchedDoctor!.imageUrl,
          biography: fetchedDoctor!.biography,
          experience: fetchedDoctor!.experience.toString(),
          patients: fetchedDoctor!.patientCount.toString(),
          reviews: fetchedDoctor!.rating.toString(),
          email: fetchedDoctor!.email,
          nationalId: fetchedDoctor!.nationalId,
          phoneNumber: fetchedDoctor!.phoneNumber,
          gender: fetchedDoctor!.gender,
          diplomaNo: fetchedDoctor!.diplomaNo,
          selectedBranchId: fetchedDoctor!.branchId?.toString() ?? '',
          branches: branches,
          acceptedInsurances: List.from(fetchedDoctor!.acceptedInsurances),
          subSpecialties: List.from(fetchedDoctor!.subSpecialties),
          professionalExperiences: List.from(
            fetchedDoctor!.professionalExperiences,
          ),
          educations: List.from(fetchedDoctor!.educations),
          schedules: fetchedDoctor!.schedules
              .map(
                (s) => {
                  'id': s.id,
                  'dayOfWeek': s.dayOfWeek,
                  'startTime': s.startTime,
                  'endTime': s.endTime,
                },
              )
              .toList(),
        ),
      );
    } else {
      emit(state.copyWith(isLoadingData: false, branches: branches));
    }
  }

  void fullNameChanged(String val) => emit(state.copyWith(fullName: val));
  void titleChanged(String val) => emit(state.copyWith(title: val));
  void specialtyChanged(String val) => emit(state.copyWith(specialty: val));
  void imageUrlChanged(String val) => emit(state.copyWith(imageUrl: val));
  void biographyChanged(String val) => emit(state.copyWith(biography: val));
  void experienceChanged(String val) => emit(state.copyWith(experience: val));
  void patientsChanged(String val) => emit(state.copyWith(patients: val));
  void reviewsChanged(String val) => emit(state.copyWith(reviews: val));
  void emailChanged(String val) => emit(state.copyWith(email: val));
  void nationalIdChanged(String val) => emit(state.copyWith(nationalId: val));
  void phoneChanged(String val) => emit(state.copyWith(phoneNumber: val));
  void diplomaChanged(String val) => emit(state.copyWith(diplomaNo: val));

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

  void genderChanged(String? val) {
    if (val != null) emit(state.copyWith(gender: val));
  }

  void updateInsurances(List<String> list) =>
      emit(state.copyWith(acceptedInsurances: List.from(list)));

  void updateSubSpecialties(List<String> list) =>
      emit(state.copyWith(subSpecialties: List.from(list)));

  void updateExperiences(List<String> list) =>
      emit(state.copyWith(professionalExperiences: List.from(list)));

  void updateEducations(List<String> list) =>
      emit(state.copyWith(educations: List.from(list)));

  void addSchedule(Map<String, dynamic> schedule) {
    final newList = List<Map<String, dynamic>>.from(state.schedules)
      ..add(schedule);
    emit(state.copyWith(schedules: newList));
  }

  void removeSchedule(int index) {
    final newList = List<Map<String, dynamic>>.from(state.schedules)
      ..removeAt(index);
    emit(state.copyWith(schedules: newList));
  }

  Future<void> submitForm() async {
    if (!state.isValid) {
      emit(
        state.copyWith(
          status: EditDoctorStatus.failure,

          errorMessage: "fillAllRequiredFields",
        ),
      );
      return;
    }

    emit(state.copyWith(status: EditDoctorStatus.loading));

    final params = UpdateDoctorParams(
      id: int.parse(state.id),
      fullName: state.fullName,
      title: state.title,
      specialty: state.specialty,
      imageUrl: state.imageUrl,
      biography: state.biography,
      branchId: int.tryParse(state.selectedBranchId ?? '0') ?? 0,
      experience: int.tryParse(state.experience) ?? 0,
      patients: state.patients,
      reviews: state.reviews,
      email: state.email,
      nationalId: state.nationalId,
      phoneNumber: state.phoneNumber,
      gender: state.gender,
      diplomaNo: state.diplomaNo,
      acceptedInsurances: state.acceptedInsurances,
      subSpecialties: state.subSpecialties,
      professionalExperiences: state.professionalExperiences,
      educations: state.educations,
      schedules: state.schedules,
    );

    final result = await _updateDoctorUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EditDoctorStatus.failure,
          errorMessage: failure.errorMessage,
        ),
      ),
      (_) => emit(state.copyWith(status: EditDoctorStatus.success)),
    );
  }
}
