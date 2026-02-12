import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/cancel_appointment_usecase.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/reschedule_appointment_usecase.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_event.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_state.dart';

class AppointmentActionBloc
    extends Bloc<AppointmentActionEvent, AppointmentActionState> {
  final CancelAppointmentUseCase _cancelAppointmentUseCase;
  final RescheduleAppointmentUseCase _rescheduleAppointmentUseCase;

  AppointmentActionBloc({
    required CancelAppointmentUseCase cancelAppointmentUseCase,
    required RescheduleAppointmentUseCase rescheduleAppointmentUseCase,
  }) : _cancelAppointmentUseCase = cancelAppointmentUseCase,
       _rescheduleAppointmentUseCase = rescheduleAppointmentUseCase,
       super(ActionInitial()) {
    on<CancelAppointmentEvent>((event, emit) async {
      emit(ActionLoading());

      final id = int.tryParse(event.appointmentId);
      if (id == null) {
        emit(const ActionError("invalidId"));
        return;
      }

      final result = await _cancelAppointmentUseCase(id);

      result.fold(
        (failure) => emit(ActionError(failure.errorMessage)),

        (_) => emit(const ActionSuccess("appointmentCanceledSuccessfully")),
      );
    });

    on<RescheduleAppointmentEvent>((event, emit) async {
      emit(ActionLoading());
      final id = int.tryParse(event.appointmentId);
      if (id == null) {
        emit(const ActionError("invalidId"));
        return;
      }

      final result = await _rescheduleAppointmentUseCase(id, event.newDate);

      result.fold((failure) => emit(ActionError(failure.errorMessage)), (
        success,
      ) {
        if (success) {
          emit(const ActionSuccess("appointmentRescheduledSuccess"));
        } else {
          emit(const ActionError("appointmentRescheduleFailed"));
        }
      });
    });

    on<NotifyAppointmentUpdated>((event, emit) {
      emit(ActionSuccess(event.message));
    });
  }
}
