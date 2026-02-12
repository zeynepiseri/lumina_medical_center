import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/appointment/domain/repositories/appointment_repository.dart';

class UpdateAppointmentUseCase {
  final AppointmentRepository _repository;

  UpdateAppointmentUseCase(this._repository);

  Future<Either<Failure, bool>> call({
    required int appointmentId,
    required DateTime newDate,
    required String type,
    String? consultationMethod,
  }) async {
    return await _repository.updateAppointment(
      appointmentId: appointmentId,
      newDate: newDate,
      type: type,
      consultationMethod: consultationMethod,
    );
  }
}
