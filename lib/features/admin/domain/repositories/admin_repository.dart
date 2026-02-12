import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/specialty_entity.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';
import '../entities/admin_stats_entity.dart';
import '../usecases/add_doctor_usecase.dart';
import '../usecases/update_doctor_usecase.dart';

abstract class AdminRepository {
  Future<Either<Failure, AdminStatsEntity>> getDashboardStats();
  Future<Either<Failure, void>> addDoctor(AddDoctorParams params);
  Future<Either<Failure, List<SpecialtyEntity>>> getSpecialties();
  Future<Either<Failure, void>> updateDoctor(UpdateDoctorParams params);
  Future<Either<Failure, List<AdminDoctorEntity>>> getAllDoctors();
  Future<Either<Failure, AdminDoctorEntity>> getDoctorById(int id);
}
