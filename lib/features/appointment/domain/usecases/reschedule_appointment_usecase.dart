import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import '../repositories/appointment_repository.dart';

class RescheduleAppointmentUseCase {
  final AppointmentRepository _repository;

  RescheduleAppointmentUseCase(this._repository);

  Future<Either<Failure, bool>> call(
    int appointmentId,
    DateTime newDate,
  ) async {
    return await _repository.rescheduleAppointment(appointmentId, newDate);
  }
}
