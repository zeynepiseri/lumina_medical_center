import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/update_appointment_usecase.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';

import 'package:lumina_medical_center/features/appointment/domain/usecases/get_booked_slots_usecase.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/create_appointment_usecase.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetBookedSlotsUseCase _getBookedSlotsUseCase;
  final CreateAppointmentUseCase _createAppointmentUseCase;
  final UpdateAppointmentUseCase _updateAppointmentUseCase;

  BookingBloc({
    required GetBookedSlotsUseCase getBookedSlotsUseCase,
    required CreateAppointmentUseCase createAppointmentUseCase,
    required UpdateAppointmentUseCase updateAppointmentUseCase,
  }) : _getBookedSlotsUseCase = getBookedSlotsUseCase,
       _createAppointmentUseCase = createAppointmentUseCase,
       _updateAppointmentUseCase = updateAppointmentUseCase,
       super(const BookingState()) {
    on<LoadBookingSlots>((event, emit) async {
      emit(state.copyWith(status: BookingStatus.loading));

      final days = List.generate(
        14,
        (i) => DateTime.now().add(Duration(days: i)),
      );

      final result = await _getBookedSlotsUseCase(event.doctorId);

      result.fold(
        (failure) => emit(
          state.copyWith(
            status: BookingStatus.failure,
            errorMessage: failure.errorMessage,
          ),
        ),
        (slots) => emit(
          state.copyWith(
            status: BookingStatus.loaded,
            bookedSlots: slots,
            next14Days: days,
          ),
        ),
      );
    });

    on<SelectDate>((event, emit) {
      final index = state.next14Days.indexOf(event.date);
      emit(state.copyWith(selectedDateIndex: index, selectedTime: null));
    });

    on<SelectTime>((event, emit) {
      emit(state.copyWith(selectedTime: event.time));
    });

    on<ChangeAppointmentType>((event, emit) {
      emit(
        state.copyWith(
          selectedTabIndex: event.tabIndex,
          selectedConsultationIndex: -1,
        ),
      );
    });

    on<ChangeConsultationMethod>((event, emit) {
      emit(state.copyWith(selectedConsultationIndex: event.index));
    });

    on<ConfirmBooking>(_onConfirmBooking);
  }

  Future<void> _onConfirmBooking(
    ConfirmBooking event,
    Emitter<BookingState> emit,
  ) async {
    if (state.selectedDateIndex == -1 || state.selectedTime == null) {
      emit(
        state.copyWith(
          status: BookingStatus.failure,

          errorMessage: "selectDateAndTime",
        ),
      );
      emit(state.copyWith(status: BookingStatus.loaded, errorMessage: null));
      return;
    }

    if (state.selectedTabIndex == 1 && state.selectedConsultationIndex == -1) {
      emit(
        state.copyWith(
          status: BookingStatus.failure,

          errorMessage: "selectConsultationType",
        ),
      );
      emit(state.copyWith(status: BookingStatus.loaded, errorMessage: null));
      return;
    }

    emit(state.copyWith(status: BookingStatus.submitting));

    try {
      final selectedDay = state.selectedDate!;
      final timeParts = state.selectedTime!.split(':');
      final targetDateTime = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      String type = state.selectedTabIndex == 1 ? "Online" : "In-Person";
      String? method;

      if (type == "Online") {
        switch (state.selectedConsultationIndex) {
          case 0:
            method = "Message";
            break;
          case 1:
            method = "Phone Call";
            break;
          case 2:
            method = "Video Call";
            break;
          default:
            method = "Video Call";
        }
      } else {
        method = "In Person";
      }

      final Either<Failure, bool> result;

      if (event.appointmentId != null) {
        result = await _updateAppointmentUseCase(
          appointmentId: event.appointmentId!,
          newDate: targetDateTime,
          type: type,
          consultationMethod: method,
        );
      } else {
        result = await _createAppointmentUseCase(
          doctorId: event.doctor.id,
          appointmentTime: targetDateTime,
          type: type,
          consultationMethod: method,
        );
      }

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: BookingStatus.failure,
              errorMessage: failure.errorMessage,
            ),
          );
          emit(state.copyWith(status: BookingStatus.loaded));
        },
        (success) {
          emit(state.copyWith(status: BookingStatus.success));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BookingStatus.failure,

          errorMessage: "unexpectedError",
        ),
      );
      emit(state.copyWith(status: BookingStatus.loaded));
    }
  }
}
