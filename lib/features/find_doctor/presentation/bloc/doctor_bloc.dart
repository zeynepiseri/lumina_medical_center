import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_doctors_usecase.dart';
import 'doctor_event.dart';
import 'doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final GetDoctorsUseCase _getDoctorsUseCase;

  DoctorBloc(this._getDoctorsUseCase) : super(DoctorInitial()) {
    on<LoadDoctors>(_onLoadDoctors);
  }

  Future<void> _onLoadDoctors(
    LoadDoctors event,
    Emitter<DoctorState> emit,
  ) async {
    emit(DoctorLoading());

    final result = await _getDoctorsUseCase(branchId: event.branchId);

    result.fold(
      (failure) => emit(DoctorError(failure.errorMessage)),
      (doctors) => emit(DoctorLoaded(doctors)),
    );
  }
}
