import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';

enum DoctorListStatus { initial, loading, success, failure }

class AdminDoctorListState extends Equatable {
  final DoctorListStatus status;
  final List<AdminDoctorEntity> allDoctors;
  final List<AdminDoctorEntity> filteredDoctors;
  final String? errorMessage;

  const AdminDoctorListState({
    this.status = DoctorListStatus.initial,
    this.allDoctors = const [],
    this.filteredDoctors = const [],
    this.errorMessage,
  });

  AdminDoctorListState copyWith({
    DoctorListStatus? status,
    List<AdminDoctorEntity>? allDoctors,
    List<AdminDoctorEntity>? filteredDoctors,
    String? errorMessage,
  }) {
    return AdminDoctorListState(
      status: status ?? this.status,
      allDoctors: allDoctors ?? this.allDoctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allDoctors,
    filteredDoctors,
    errorMessage,
  ];
}
