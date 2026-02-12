import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/appointment/data/datasources/appointment_service.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/doctor_dashboard_event.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/doctor_dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AppointmentService _service;

  DashboardBloc(this._service) : super(DashboardInitial()) {
    on<LoadAppointmentsByDate>(_onLoadAppointments);
  }

  Future<void> _onLoadAppointments(
    LoadAppointmentsByDate event,
    Emitter<DashboardState> emit,
  ) async {
    if (!event.forceRefresh &&
        state is DashboardLoaded &&
        (state as DashboardLoaded).selectedDate == event.date) {
      return;
    }
    emit(DashboardLoading());

    try {
      final appointments = await _service.getAppointmentsByDate(event.date);

      appointments.sort(
        (a, b) => a.appointmentTime.compareTo(b.appointmentTime),
      );

      emit(DashboardLoaded(appointments, event.date));
    } catch (e) {
      emit(const DashboardError("dashboardLoadError"));
    }
  }
}
