import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';

class AdminDoctorModel extends AdminDoctorEntity {
  const AdminDoctorModel({
    required super.id,
    required super.fullName,
    required super.title,
    required super.specialty,
    required super.imageUrl,
    required super.biography,
    required super.experience,
    required super.patientCount,
    required super.rating,
    required super.reviewCount,
    super.branchName,
    super.branchId,
    required super.email,
    required super.phoneNumber,
    required super.nationalId,
    required super.gender,
    required super.diplomaNo,
    required super.birthDate,
    required super.subSpecialties,
    required super.professionalExperiences,
    required super.educations,
    required super.acceptedInsurances,
    required List<AdminWorkSchedule> schedules,
  }) : super(schedules: schedules);

  factory AdminDoctorModel.fromJson(Map<String, dynamic> json) {
    return AdminDoctorModel(
      id: json['id'] as int? ?? 0,
      fullName: json['fullName'] as String? ?? 'Unknown',
      title: json['title'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      biography: json['biography'] as String? ?? '',
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      patientCount: (json['patientCount'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      branchName: json['branchName'] as String? ?? '',
      branchId: json['branchId'] as int?,
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      nationalId: json['nationalId'] as String? ?? '',
      gender: json['gender'] as String? ?? 'Male',
      diplomaNo: json['diplomaNo'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',

      subSpecialties: json['subSpecialties'] != null
          ? List<String>.from(json['subSpecialties'].map((x) => x.toString()))
          : [],
      professionalExperiences: json['professionalExperiences'] != null
          ? List<String>.from(
              json['professionalExperiences'].map((x) => x.toString()),
            )
          : [],
      educations: json['educations'] != null
          ? List<String>.from(json['educations'].map((x) => x.toString()))
          : [],
      acceptedInsurances: json['acceptedInsurances'] != null
          ? List<String>.from(
              json['acceptedInsurances'].map((x) => x.toString()),
            )
          : [],

      schedules: json['schedules'] != null
          ? (json['schedules'] as List)
                .map((e) => AdminWorkScheduleModel.fromJson(e))
                .toList()
          : [],
    );
  }
}

class AdminWorkScheduleModel extends AdminWorkSchedule {
  const AdminWorkScheduleModel({
    super.id,
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
  });

  factory AdminWorkScheduleModel.fromJson(Map<String, dynamic> json) {
    return AdminWorkScheduleModel(
      id: json['id'] as int?,
      dayOfWeek: json['dayOfWeek'] ?? 'MONDAY',
      startTime: json['startTime'] ?? '09:00',
      endTime: json['endTime'] ?? '17:00',
    );
  }
}
