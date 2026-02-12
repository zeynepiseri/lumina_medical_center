import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/top_doctor_entity.dart';

class AdminStatsEntity extends Equatable {
  final int totalPatients;
  final int totalDoctors;
  final int totalAppointments;
  final double monthlyEarnings;
  final List<int> monthlyAppointmentsData;
  final List<String> monthLabels;
  final String topDoctorName;
  final String topDoctorBranch;
  final List<TopDoctorEntity> topDoctors;

  const AdminStatsEntity({
    required this.totalPatients,
    required this.totalDoctors,
    required this.totalAppointments,
    required this.monthlyEarnings,
    required this.monthlyAppointmentsData,
    required this.monthLabels,
    required this.topDoctorName,
    required this.topDoctorBranch,
    required this.topDoctors,
  });

  @override
  List<Object?> get props => [
    totalPatients,
    totalDoctors,
    totalAppointments,
    monthlyEarnings,
    monthlyAppointmentsData,
    monthLabels,
    topDoctorName,
    topDoctorBranch,
    topDoctors,
  ];
}
