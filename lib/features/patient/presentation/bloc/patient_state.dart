part of 'patient_bloc.dart';

abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object> get props => [];
}

class PatientInitial extends PatientState {}

class PatientLoading extends PatientState {}

class PatientLoaded extends PatientState {
  final PatientEntity patient;

  const PatientLoaded(this.patient);

  @override
  List<Object> get props => [patient];
}

class PatientError extends PatientState {
  final Failure failure;

  const PatientError(this.failure);

  @override
  List<Object> get props => [failure];
}

class PatientVitalsUpdated extends PatientState {
  final String message;
  const PatientVitalsUpdated(this.message);

  @override
  List<Object> get props => [message];
}
