import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_schedule_entity.dart';

class DoctorScheduleModel extends ScheduleEntity {
  const DoctorScheduleModel({
    super.id,
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
  });

  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      dayOfWeek: json['dayOfWeek'] ?? 'MONDAY',
      startTime: json['startTime'] ?? '09:00',
      endTime: json['endTime'] ?? '17:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
