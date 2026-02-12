part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class LoadBookingSlots extends BookingEvent {
  final int doctorId;
  final int? appointmentId;

  const LoadBookingSlots({required this.doctorId, this.appointmentId});

  @override
  List<Object?> get props => [doctorId, appointmentId];
}

class SelectDate extends BookingEvent {
  final DateTime date;
  const SelectDate(this.date);
}

class SelectTime extends BookingEvent {
  final String time;
  const SelectTime(this.time);
}

class ChangeAppointmentType extends BookingEvent {
  final int tabIndex;
  const ChangeAppointmentType(this.tabIndex);
}

class ChangeConsultationMethod extends BookingEvent {
  final int index;
  const ChangeConsultationMethod(this.index);
}

class SelectConsultationType extends BookingEvent {
  final int index;
  const SelectConsultationType(this.index);
}

class ConfirmBooking extends BookingEvent {
  final DoctorEntity doctor;
  final int? appointmentId;

  const ConfirmBooking({required this.doctor, this.appointmentId});
}
