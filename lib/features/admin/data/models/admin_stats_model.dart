import 'package:lumina_medical_center/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/top_doctor_entity.dart';

class AdminStatsModel extends AdminStatsEntity {
  const AdminStatsModel({
    required super.totalPatients,
    required super.totalDoctors,
    required super.totalAppointments,
    required super.monthlyEarnings,
    required super.monthlyAppointmentsData,
    required super.monthLabels,
    required super.topDoctorName,
    required super.topDoctorBranch,
    required super.topDoctors,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      totalPatients: json['totalPatients'] ?? 0,
      totalDoctors: json['totalDoctors'] ?? 0,
      totalAppointments: json['totalAppointments'] ?? 0,
      monthlyEarnings: (json['monthlyEarnings'] as num?)?.toDouble() ?? 0.0,
      monthlyAppointmentsData: List<int>.from(
        json['monthlyAppointmentsData'] ?? [],
      ),
      monthLabels: List<String>.from(json['monthLabels'] ?? []),
      topDoctorName: json['topDoctorName'] ?? 'N/A',
      topDoctorBranch: json['topDoctorBranch'] ?? '',
      topDoctors:
          (json['topDoctors'] as List<dynamic>?)
              ?.map((e) => TopDoctorModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TopDoctorModel extends TopDoctorEntity {
  const TopDoctorModel({
    required super.name,
    required super.branch,
    required super.appointmentCount,
    super.imageUrl,
    required super.rating,

    required super.specialty,
    required super.earnings,
  });

  factory TopDoctorModel.fromJson(Map<String, dynamic> json) {
    return TopDoctorModel(
      name: json['name'] ?? 'Unknown',
      branch: json['branch'] ?? 'General',
      appointmentCount: json['appointmentCount'] ?? 0,
      imageUrl: json['imageUrl'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,

      specialty: json['specialty'] ?? '',
      earnings: (json['earnings'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
