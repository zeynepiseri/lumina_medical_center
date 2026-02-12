import 'package:lumina_medical_center/features/doctor_dashboard/domain/entities/my_profile_entity.dart';

class MyProfileModel extends MyProfileEntity {
  const MyProfileModel({
    required super.id,
    required super.fullName,
    required super.title,
    required super.branchName,
    required super.biography,
    required super.experience,
    required super.diplomaNo,
    super.email,
    super.phoneNumber,
    super.nationalId,
    required super.imageUrl,
    required super.schedules,
    required super.subSpecialties,
    required super.educations,
    required super.patientCount,
  });

  factory MyProfileModel.fromJson(Map<String, dynamic> json) {
    return MyProfileModel(
      id: json['id'] as int? ?? 0,
      fullName: json['fullName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      branchName: json['branchName'] as String? ?? '',
      biography: json['biography'] as String? ?? '',
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      diplomaNo: json['diplomaNo'] as String? ?? '',
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      nationalId: json['nationalId'] as String?,
      imageUrl: json['imageUrl'] as String? ?? '',
      patientCount: (json['patientCount'] as num?)?.toInt() ?? 0,

      subSpecialties: json['subSpecialties'] != null
          ? List<String>.from(json['subSpecialties'].map((x) => x.toString()))
          : [],
      educations: json['educations'] != null
          ? List<String>.from(json['educations'].map((x) => x.toString()))
          : [],

      schedules: json['schedules'] != null
          ? (json['schedules'] as List)
                .map(
                  (e) => WorkScheduleModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }
}

class WorkScheduleModel extends WorkSchedule {
  const WorkScheduleModel({
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
  });

  factory WorkScheduleModel.fromJson(Map<String, dynamic> json) {
    return WorkScheduleModel(
      dayOfWeek: json['dayOfWeek'] ?? 'MONDAY',
      startTime: json['startTime'] ?? '09:00',
      endTime: json['endTime'] ?? '17:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {'dayOfWeek': dayOfWeek, 'startTime': startTime, 'endTime': endTime};
  }
}
