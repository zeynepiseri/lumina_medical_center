import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';

abstract class DoctorRepository {
  Future<Either<Failure, List<DoctorEntity>>> getDoctors({String? branchId});
  Future<Either<Failure, DoctorEntity>> getDoctorById(int id);
}
