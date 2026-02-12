import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/appointment/domain/repositories/appointment_repository.dart';

class CreateAppointmentUseCase {
  final AppointmentRepository _repository;

  CreateAppointmentUseCase(this._repository);

  Future<Either<Failure, bool>> call({
    required int doctorId,
    required DateTime appointmentTime,
    required String type,
    String? consultationMethod,
  }) async {
    return await _repository.createAppointment(
      doctorId: doctorId,
      appointmentTime: appointmentTime,
      type: type,
      consultationMethod: consultationMethod,
    );
  }
}
