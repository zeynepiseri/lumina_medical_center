import 'package:lumina_medical_center/features/find_doctor/data/models/doctor_schedule_model.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';

class DoctorModel extends DoctorEntity {
  const DoctorModel({
    required super.id,
    required super.fullName,
    required super.title,
    required super.specialty,
    required super.imageUrl,
    required super.branchName,
    super.branchId,
    required super.biography,
    required super.rating,
    required super.reviewCount,
    required super.patientCount,
    required super.experience,
    required super.consultationFee,
    required super.subSpecialties,
    required super.professionalExperiences,
    required super.educations,
    required super.certificates,
    required super.languages,
    required super.acceptedInsurances,
    required List<DoctorScheduleModel> schedules,
    super.type = 'General',
  }) : super(schedules: schedules);

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as int? ?? 0,
      fullName: json['fullName'] as String? ?? 'Unknown Doctor',
      title: json['title'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      branchName: json['branchName'] as String? ?? '',
      branchId: json['branchId'] as int?,
      biography: json['biography'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      patientCount: (json['patientCount'] as num?)?.toInt() ?? 0,
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 0.0,

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
      certificates: json['certificates'] != null
          ? List<String>.from(json['certificates'].map((x) => x.toString()))
          : [],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'].map((x) => x.toString()))
          : [],
      acceptedInsurances: json['acceptedInsurances'] != null
          ? List<String>.from(
              json['acceptedInsurances'].map((x) => x.toString()),
            )
          : [],

      schedules: json['schedules'] != null
          ? (json['schedules'] as List)
                .map(
                  (e) =>
                      DoctorScheduleModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : [],

      type: json['type'] ?? 'General',
    );
  }
}
