import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';
import 'package:lumina_medical_center/features/admin/domain/usecases/get_all_doctors_usecase.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_doctor_list/admin_doctor_list_state.dart';

class AdminDoctorListCubit extends Cubit<AdminDoctorListState> {
  final GetAllDoctorsUseCase _getDoctorsUseCase;

  AdminDoctorListCubit(this._getDoctorsUseCase)
    : super(const AdminDoctorListState());

  Future<void> loadDoctors() async {
    emit(state.copyWith(status: DoctorListStatus.loading));
    final result = await _getDoctorsUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DoctorListStatus.failure,
          errorMessage: failure.errorMessage,
        ),
      ),
      (doctors) => emit(
        state.copyWith(
          status: DoctorListStatus.success,
          allDoctors: doctors,
          filteredDoctors: doctors,
        ),
      ),
    );
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(filteredDoctors: state.allDoctors));
      return;
    }
    final lowerQuery = query.toLowerCase();
    final filtered = state.allDoctors.where((doc) {
      return doc.fullName.toLowerCase().contains(lowerQuery) ||
          doc.specialty.toLowerCase().contains(lowerQuery);
    }).toList();
    emit(state.copyWith(filteredDoctors: filtered));
  }
}
