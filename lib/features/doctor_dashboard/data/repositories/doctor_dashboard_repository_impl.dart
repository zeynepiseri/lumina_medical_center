import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/data/datasources/doctor_profile_service.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/entities/my_profile_entity.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/repositories/doctor_dashboard_repository.dart';

class DoctorDashboardRepositoryImpl implements DoctorDashboardRepository {
  final DoctorProfileService _service;

  DoctorDashboardRepositoryImpl(this._service);

  @override
  Future<Either<Failure, MyProfileEntity>> getMyProfile() async {
    try {
      const int currentUserId = 123;

      final result = await _service.getMyProfile(currentUserId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorCode: e.code, debugMessage: e.message));
    } catch (e) {
      return Left(UnknownFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile({
    required String biography,
    required int experience,
    required List<WorkSchedule> schedules,
    required List<String> subSpecialties,
    required List<String> educations,
    String? imageUrl,
  }) async {
    try {
      const int currentUserId = 123;

      final scheduleMaps = schedules
          .map(
            (e) => {
              'dayOfWeek': e.dayOfWeek,
              'startTime': e.startTime,
              'endTime': e.endTime,
            },
          )
          .toList();

      await _service.updateProfile(
        userId: currentUserId,
        biography: biography,
        experience: experience,
        schedules: scheduleMaps,
        subSpecialties: subSpecialties,
        educations: educations,
        imageUrl: imageUrl,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorCode: e.code, debugMessage: e.message));
    } catch (e) {
      return Left(UnknownFailure(debugMessage: e.toString()));
    }
  }
}
