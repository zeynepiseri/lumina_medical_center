import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';

enum AppointmentManagementStatus { initial, loading, success, failure }

class AppointmentManagementState extends Equatable {
  final AppointmentManagementStatus status;
  final List<AppointmentEntity> allAppointments;
  final List<AppointmentEntity> filteredAppointments;
  final List<AdminDoctorEntity> doctors;
  final String? errorMessage;

  final DateTime? selectedDate;
  final String? selectedStatus;
  final int? selectedDoctorId;

  const AppointmentManagementState({
    this.status = AppointmentManagementStatus.initial,
    this.allAppointments = const [],
    this.filteredAppointments = const [],
    this.doctors = const [],
    this.errorMessage,
    this.selectedDate,
    this.selectedStatus,
    this.selectedDoctorId,
  });

  AppointmentManagementState copyWith({
    AppointmentManagementStatus? status,
    List<AppointmentEntity>? allAppointments,
    List<AppointmentEntity>? filteredAppointments,
    List<AdminDoctorEntity>? doctors,
    String? errorMessage,
    DateTime? selectedDate,
    String? selectedStatus,
    int? selectedDoctorId,
  }) {
    return AppointmentManagementState(
      status: status ?? this.status,
      allAppointments: allAppointments ?? this.allAppointments,
      filteredAppointments: filteredAppointments ?? this.filteredAppointments,
      doctors: doctors ?? this.doctors,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedDoctorId: selectedDoctorId ?? this.selectedDoctorId,
    );
  }

  AppointmentManagementState clearFilters() {
    return AppointmentManagementState(
      status: status,
      allAppointments: allAppointments,
      filteredAppointments: allAppointments,
      doctors: doctors,
      errorMessage: errorMessage,
      selectedDate: null,
      selectedStatus: null,
      selectedDoctorId: null,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allAppointments,
    filteredAppointments,
    doctors,
    errorMessage,
    selectedDate,
    selectedStatus,
    selectedDoctorId,
  ];
}
