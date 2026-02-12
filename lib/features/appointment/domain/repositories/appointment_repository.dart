import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, List<AppointmentEntity>>> getMyAppointments();
  Future<Either<Failure, List<AppointmentEntity>>> getAllAppointments();
  Future<Either<Failure, void>> cancelAppointment(int appointmentId);

  Future<Either<Failure, bool>> rescheduleAppointment(
    int appointmentId,
    DateTime newDate,
  );

  Future<Either<Failure, List<DateTime>>> getBookedSlots(int doctorId);

  Future<Either<Failure, bool>> createAppointment({
    required int doctorId,
    required DateTime appointmentTime,
    required String type,
    String? consultationMethod,
  });

  Future<Either<Failure, bool>> updateAppointment({
    required int appointmentId,
    required DateTime newDate,
    required String type,
    String? consultationMethod,
  });
}
