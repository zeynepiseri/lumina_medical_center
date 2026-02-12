import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.appointmentTime,
    required super.status,
    required super.doctorId,
    required super.doctorName,
    required super.doctorTitle,
    required super.doctorSpecialty,
    required super.doctorImageUrl,
    required super.patientId,
    required super.patientName,
    required super.healthIssue,
    required super.appointmentType,
    super.consultationMethod,
    required super.isAvailable,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as int? ?? 0,

      appointmentTime: json['appointmentTime'] as String? ?? '',
      status: json['status'] as String? ?? 'Pending',

      doctorId: json['doctorId'] as int? ?? 0,
      doctorName: json['doctorName'] as String? ?? 'Unknown Doctor',
      doctorTitle: json['doctorTitle'] as String? ?? '',
      doctorSpecialty: json['doctorSpecialty'] as String? ?? '',
      doctorImageUrl: json['doctorImageUrl'] as String? ?? '',

      patientId: json['patientId'] as int? ?? 0,
      patientName: json['patientName'] as String? ?? 'Unknown Patient',

      healthIssue: json['healthIssue'] as String? ?? '',
      appointmentType: json['appointmentType'] as String? ?? 'General',
      consultationMethod: json['consultationMethod'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentTime': appointmentTime,
      'status': status,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorTitle': doctorTitle,
      'doctorSpecialty': doctorSpecialty,
      'doctorImageUrl': doctorImageUrl,
      'patientId': patientId,
      'patientName': patientName,
      'healthIssue': healthIssue,
      'appointmentType': appointmentType,
      'consultationMethod': consultationMethod,
      'isAvailable': isAvailable,
    };
  }
}
