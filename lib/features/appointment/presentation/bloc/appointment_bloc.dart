import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/cancel_appointment_usecase.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/get_my_appointments_usecase.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/appointment_event.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetMyAppointmentsUseCase _getMyAppointmentsUseCase;
  final CancelAppointmentUseCase _cancelAppointmentUseCase;

  AppointmentBloc({
    required GetMyAppointmentsUseCase getMyAppointmentsUseCase,
    required CancelAppointmentUseCase cancelAppointmentUseCase,
  }) : _getMyAppointmentsUseCase = getMyAppointmentsUseCase,
       _cancelAppointmentUseCase = cancelAppointmentUseCase,
       super(const AppointmentState()) {
    on<LoadAppointmentsEvent>(_onLoadAppointments);
    on<CancelAppointmentEvent>(_onCancelAppointment);
  }

  Future<void> _onLoadAppointments(
    LoadAppointmentsEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(state.copyWith(status: AppointmentStatus.loading));

    final result = await _getMyAppointmentsUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AppointmentStatus.failure,
          errorMessage: failure.errorMessage,
        ),
      ),
      (appointments) {
        try {
          final now = DateTime.now();

          final upcoming = appointments.where((a) {
            if (a.status == 'Cancelled') return false;
            final date = DateTime.tryParse(a.appointmentTime);
            return date != null && date.isAfter(now);
          }).toList();

          final past = appointments.where((a) {
            final date = DateTime.tryParse(a.appointmentTime);
            return date == null ||
                date.isBefore(now) ||
                a.status == 'Cancelled';
          }).toList();

          upcoming.sort((a, b) {
            final dateA = DateTime.tryParse(a.appointmentTime) ?? DateTime(0);
            final dateB = DateTime.tryParse(b.appointmentTime) ?? DateTime(0);
            return dateA.compareTo(dateB);
          });

          past.sort((a, b) {
            final dateA = DateTime.tryParse(a.appointmentTime) ?? DateTime(0);
            final dateB = DateTime.tryParse(b.appointmentTime) ?? DateTime(0);
            return dateB.compareTo(dateA);
          });

          emit(
            state.copyWith(
              status: AppointmentStatus.success,
              upcomingAppointments: upcoming,
              pastAppointments: past,
            ),
          );
        } catch (e) {
          emit(
            state.copyWith(
              status: AppointmentStatus.failure,

              errorMessage: "anErrorHasOccurred",
            ),
          );
        }
      },
    );
  }

  Future<void> _onCancelAppointment(
    CancelAppointmentEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    final result = await _cancelAppointmentUseCase(event.appointmentId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AppointmentStatus.failure,
          errorMessage: failure.errorMessage,
        ),
      ),
      (_) {
        add(LoadAppointmentsEvent());
      },
    );
  }
}
