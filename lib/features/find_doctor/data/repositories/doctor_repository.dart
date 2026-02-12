import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/find_doctor/data/datasources/doctor_service.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorService _service;

  DoctorRepositoryImpl(this._service);

  @override
  Future<Either<Failure, List<DoctorEntity>>> getDoctors({
    String? branchId,
  }) async {
    try {
      final doctorModels = await _service.getDoctors(branchId: branchId);
      final entities = doctorModels.map((e) => e as DoctorEntity).toList();
      return Right(entities);
    } on DioException catch (e) {
      return Left(ServerFailure(debugMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DoctorEntity>> getDoctorById(int id) async {
    try {
      final doctorModel = await _service.getDoctorById(id);
      if (doctorModel == null) {
        return const Left(ServerFailure(debugMessage: "Doctor not found"));
      }
      return Right(doctorModel);
    } on DioException catch (e) {
      return Left(ServerFailure(debugMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }
}
