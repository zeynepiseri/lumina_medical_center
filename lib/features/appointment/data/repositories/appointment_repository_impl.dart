import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/appointment/data/datasources/appointment_service.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';
import 'package:lumina_medical_center/features/appointment/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentService _service;

  AppointmentRepositoryImpl(this._service);

  @override
  Future<Either<Failure, List<DateTime>>> getBookedSlots(int doctorId) async {
    try {
      final result = await _service.getBookedSlots(doctorId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createAppointment({
    required int doctorId,
    required DateTime appointmentTime,
    required String type,
    String? consultationMethod,
  }) async {
    try {
      final result = await _service.createAppointment(
        doctorId,
        appointmentTime,
        type,
        consultationMethod,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateAppointment({
    required int appointmentId,
    required DateTime newDate,
    required String type,
    String? consultationMethod,
  }) async {
    try {
      final result = await _service.updateAppointment(
        appointmentId,
        newDate,
        type,
        consultationMethod,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> rescheduleAppointment(
    int appointmentId,
    DateTime newDate,
  ) async {
    try {
      final result = await _service.rescheduleAppointment(
        appointmentId,
        newDate,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAllAppointments() async {
    try {
      final result = await _service.getAllAppointmentsForAdmin();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getMyAppointments() async {
    try {
      final result = await _service.getMyAppointments();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment(int appointmentId) async {
    try {
      await _service.deleteAppointment(appointmentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }
}
