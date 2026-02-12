import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/appointment/domain/repositories/appointment_repository.dart';

class GetBookedSlotsUseCase {
  final AppointmentRepository _repository;

  GetBookedSlotsUseCase(this._repository);

  Future<Either<Failure, List<DateTime>>> call(int doctorId) async {
    return await _repository.getBookedSlots(doctorId);
  }
}
