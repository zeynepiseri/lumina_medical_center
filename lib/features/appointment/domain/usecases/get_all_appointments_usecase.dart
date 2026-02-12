import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';
import 'package:lumina_medical_center/features/appointment/domain/repositories/appointment_repository.dart';

class GetAllAppointmentsUseCase {
  final AppointmentRepository _repository;

  GetAllAppointmentsUseCase(this._repository);

  Future<Either<Failure, List<AppointmentEntity>>> call() async {
    return await _repository.getAllAppointments();
  }
}
