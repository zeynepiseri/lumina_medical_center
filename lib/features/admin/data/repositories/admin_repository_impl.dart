import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/admin/data/datasources/admin_service.dart';
import 'package:lumina_medical_center/features/admin/data/mappers/doctor_mapper.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/specialty_entity.dart';
import 'package:lumina_medical_center/features/admin/domain/repositories/admin_repository.dart';
import 'package:lumina_medical_center/features/admin/domain/usecases/add_doctor_usecase.dart';
import 'package:lumina_medical_center/features/admin/domain/usecases/update_doctor_usecase.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminService _adminService;

  AdminRepositoryImpl(this._adminService);

  @override
  Future<Either<Failure, AdminStatsEntity>> getDashboardStats() async {
    try {
      final statsModel = await _adminService.getDashboardStats();
      return Right(statsModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(debugMessage: e.message));
    } on DioException catch (_) {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addDoctor(AddDoctorParams params) async {
    try {
      await _adminService.addDoctor(params.toJson());
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(debugMessage: e.message));
    } on DioException catch (_) {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SpecialtyEntity>>> getSpecialties() async {
    try {
      final models = await _adminService.getSpecialties();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(debugMessage: e.message));
    } on DioException catch (_) {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDoctor(UpdateDoctorParams params) async {
    try {
      await _adminService.updateDoctor(params.id, params.toJson());
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(debugMessage: e.message));
    } on DioException catch (_) {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdminDoctorEntity>>> getAllDoctors() async {
    try {
      final doctorModels = await _adminService.getAllDoctors();
      final entities = doctorModels.map((e) => e as AdminDoctorEntity).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(debugMessage: e.message));
    } on DioException catch (_) {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminDoctorEntity>> getDoctorById(int id) async {
    try {
      final doctorModel = await _adminService.getDoctorById(id);
      return Right(doctorModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(debugMessage: e.message));
    } on DioException catch (_) {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }
}
