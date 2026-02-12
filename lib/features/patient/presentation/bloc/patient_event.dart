part of 'patient_bloc.dart';

abstract class PatientEvent extends Equatable {
  const PatientEvent();
  @override
  List<Object> get props => [];
}

class UpdatePatientVitalsEvent extends PatientEvent {
  final double? height;
  final double? weight;
  final String? bloodType;

  const UpdatePatientVitalsEvent({this.height, this.weight, this.bloodType});

  @override
  List<Object> get props => [height ?? 0, weight ?? 0, bloodType ?? ''];
}

class LoadCurrentProfileEvent extends PatientEvent {
  const LoadCurrentProfileEvent();
}
