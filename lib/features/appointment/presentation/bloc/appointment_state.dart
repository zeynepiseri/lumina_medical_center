import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';

enum AppointmentStatus { initial, loading, success, failure }

class AppointmentState extends Equatable {
  final AppointmentStatus status;
  final List<AppointmentEntity> upcomingAppointments;
  final List<AppointmentEntity> pastAppointments;
  final String? errorMessage;

  const AppointmentState({
    this.status = AppointmentStatus.initial,
    this.upcomingAppointments = const [],
    this.pastAppointments = const [],
    this.errorMessage,
  });

  AppointmentState copyWith({
    AppointmentStatus? status,
    List<AppointmentEntity>? upcomingAppointments,
    List<AppointmentEntity>? pastAppointments,
    String? errorMessage,
  }) {
    return AppointmentState(
      status: status ?? this.status,
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      pastAppointments: pastAppointments ?? this.pastAppointments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    upcomingAppointments,
    pastAppointments,
    errorMessage,
  ];
}
