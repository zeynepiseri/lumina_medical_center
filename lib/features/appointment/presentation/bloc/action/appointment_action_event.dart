import 'package:equatable/equatable.dart';

abstract class AppointmentActionEvent extends Equatable {
  const AppointmentActionEvent();

  @override
  List<Object> get props => [];
}

class CancelAppointmentEvent extends AppointmentActionEvent {
  final String appointmentId;
  const CancelAppointmentEvent(this.appointmentId);
}

class RescheduleAppointmentEvent extends AppointmentActionEvent {
  final String appointmentId;
  final DateTime newDate;
  const RescheduleAppointmentEvent(this.appointmentId, this.newDate);
}

class NotifyAppointmentUpdated extends AppointmentActionEvent {
  final String message;
  const NotifyAppointmentUpdated(this.message);
}
