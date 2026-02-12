import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/patient/domain/usecases/update_patient_vitals_usecase.dart';
import '../../domain/entities/patient_entity.dart';

import '../../domain/usecases/get_patient_profile_usecase.dart';

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final GetPatientProfileUseCase getPatientProfile;
  final UpdatePatientVitalsUseCase updatePatientVitals;

  PatientBloc({
    required this.getPatientProfile,
    required this.updatePatientVitals,
  }) : super(PatientInitial()) {
    on<LoadCurrentProfileEvent>(_onLoadCurrentProfile);
    on<UpdatePatientVitalsEvent>(_onUpdateVitals);
  }

  Future<void> _onLoadCurrentProfile(
    LoadCurrentProfileEvent event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());

    final result = await getPatientProfile();

    result.fold(
      (failure) => emit(PatientError(failure)),
      (patient) => emit(PatientLoaded(patient)),
    );
  }

  Future<void> _onUpdateVitals(
    UpdatePatientVitalsEvent event,
    Emitter<PatientState> emit,
  ) async {
    final result = await updatePatientVitals(
      UpdatePatientVitalsParams(
        height: event.height,
        weight: event.weight,
        bloodType: event.bloodType,
      ),
    );

    result.fold(
      (failure) => emit(PatientError(failure)),
      (_) => add(const LoadCurrentProfileEvent()),
    );
  }
}
