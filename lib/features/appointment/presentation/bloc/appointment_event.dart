import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();
  @override
  List<Object?> get props => [];
}

class LoadAppointmentsEvent extends AppointmentEvent {}

class CancelAppointmentEvent extends AppointmentEvent {
  final int appointmentId;
  const CancelAppointmentEvent(this.appointmentId);
  @override
  List<Object?> get props => [appointmentId];
}
