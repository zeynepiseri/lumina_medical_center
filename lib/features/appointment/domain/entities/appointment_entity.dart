import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final int id;
  final String appointmentTime;
  final String status;
  final int doctorId;
  final String doctorName;
  final String doctorTitle;
  final String doctorSpecialty;
  final String doctorImageUrl;
  final int patientId;
  final String patientName;
  final String healthIssue;
  final String appointmentType;
  final String? consultationMethod;
  final bool isAvailable;

  const AppointmentEntity({
    required this.id,
    required this.appointmentTime,
    required this.status,
    required this.doctorId,
    required this.doctorName,
    required this.doctorTitle,
    required this.doctorSpecialty,
    required this.doctorImageUrl,
    required this.patientId,
    required this.patientName,
    required this.healthIssue,
    required this.appointmentType,
    this.consultationMethod,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [
    id,
    appointmentTime,
    status,
    doctorId,
    doctorName,
    patientId,
    patientName,
  ];
}
