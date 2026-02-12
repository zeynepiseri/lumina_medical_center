import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/appointment/domain/repositories/appointment_repository.dart';

class CancelAppointmentUseCase {
  final AppointmentRepository _repository;

  CancelAppointmentUseCase(this._repository);

  Future<Either<Failure, void>> call(int appointmentId) async {
    return await _repository.cancelAppointment(appointmentId);
  }
}
