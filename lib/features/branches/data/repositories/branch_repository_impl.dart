import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/branches/data/datasources/branch_remote_data_source.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/branches/domain/repositories/branch_repository.dart';

class BranchRepositoryImpl implements BranchRepository {
  final BranchRemoteDataSource _remoteDataSource;

  BranchRepositoryImpl({required BranchRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<BranchEntity>>> getAllBranches() async {
    try {
      final branches = await _remoteDataSource.getAllBranches();
      return Right(branches);
    } on ServerException catch (e) {
      return Left(ServerFailure(debugMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(debugMessage: "Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, BranchEntity>> createBranch(
    CreateBranchParams params,
  ) async {
    try {
      final result = await _remoteDataSource.createBranch(params.toMap());
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(debugMessage: e.message));
    } catch (e) {
      return Left(ServerFailure(debugMessage: "Unexpected error: $e"));
    }
  }
}
