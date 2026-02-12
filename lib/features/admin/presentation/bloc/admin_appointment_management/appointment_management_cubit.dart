import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';
import 'package:lumina_medical_center/features/admin/domain/usecases/get_all_doctors_usecase.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/cancel_appointment_usecase.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/get_all_appointments_usecase.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_appointment_management/appointment_management_state.dart';

class AppointmentManagementCubit extends Cubit<AppointmentManagementState> {
  final GetAllAppointmentsUseCase _getAllAppointmentsUseCase;
  final GetAllDoctorsUseCase _getAllDoctorsUseCase;
  final CancelAppointmentUseCase _cancelAppointmentUseCase;

  AppointmentManagementCubit({
    required GetAllAppointmentsUseCase getAllAppointmentsUseCase,
    required GetAllDoctorsUseCase getAllDoctorsUseCase,
    required CancelAppointmentUseCase cancelAppointmentUseCase,
  }) : _getAllAppointmentsUseCase = getAllAppointmentsUseCase,
       _getAllDoctorsUseCase = getAllDoctorsUseCase,
       _cancelAppointmentUseCase = cancelAppointmentUseCase,
       super(const AppointmentManagementState());

  Future<void> loadData() async {
    emit(state.copyWith(status: AppointmentManagementStatus.loading));

    final results = await Future.wait([
      _getAllAppointmentsUseCase(),
      _getAllDoctorsUseCase(),
    ]);

    final appointmentsResult = results[0];
    final doctorsResult = results[1];

    List<AppointmentEntity> appointments = [];
    List<AdminDoctorEntity> doctors = [];
    String? error;

    (appointmentsResult as dynamic).fold(
      (failure) => error = failure.errorMessage,
      (data) => appointments = data as List<AppointmentEntity>,
    );

    (doctorsResult as dynamic).fold(
      (failure) => error ??= failure.errorMessage,
      (data) => doctors = data as List<AdminDoctorEntity>,
    );

    if (error != null) {
      emit(
        state.copyWith(
          status: AppointmentManagementStatus.failure,
          errorMessage: error,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AppointmentManagementStatus.success,
          allAppointments: appointments,
          filteredAppointments: appointments,
          doctors: doctors,
        ),
      );
    }
  }

  void filterAppointments({DateTime? date, String? status, int? doctorId}) {
    final targetDate = date ?? state.selectedDate;
    final targetStatus = status ?? state.selectedStatus;
    final targetDoctorId = doctorId ?? state.selectedDoctorId;

    List<AppointmentEntity> filtered = state.allAppointments;

    if (targetDate != null) {
      filtered = filtered.where((appt) {
        final apptDate = appt.appointmentTime is DateTime
            ? (appt.appointmentTime as DateTime)
            : DateTime.parse(appt.appointmentTime.toString());

        return apptDate.year == targetDate.year &&
            apptDate.month == targetDate.month &&
            apptDate.day == targetDate.day;
      }).toList();
    }

    if (targetStatus != null && targetStatus != 'All') {
      filtered = filtered.where((appt) => appt.status == targetStatus).toList();
    }

    if (targetDoctorId != null) {
      filtered = filtered
          .where((appt) => appt.doctorId == targetDoctorId)
          .toList();
    }

    emit(
      state.copyWith(
        filteredAppointments: filtered,
        selectedDate: targetDate,
        selectedStatus: targetStatus,
        selectedDoctorId: targetDoctorId,
      ),
    );
  }

  void clearFilters() {
    emit(state.clearFilters());
  }

  Future<void> cancelAppointment(int appointmentId) async {
    final result = await _cancelAppointmentUseCase(appointmentId);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.errorMessage)),
      (_) {
        loadData();
      },
    );
  }
}
