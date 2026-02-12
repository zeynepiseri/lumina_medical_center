import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/auth/data/repositories/user_repository.dart';
import 'package:lumina_medical_center/features/auth/domain/entities/user_entity.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl({required UserRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();

      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateProfilePhoto(String imageUrl) async {
    try {
      final result = await _remoteDataSource.updateProfilePhoto(imageUrl);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _remoteDataSource.changePassword(currentPassword, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }
}
