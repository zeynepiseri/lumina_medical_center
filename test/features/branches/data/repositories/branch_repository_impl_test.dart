import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/branches/data/datasources/branch_remote_data_source.dart';
import 'package:lumina_medical_center/features/branches/data/models/branch_model.dart';
import 'package:lumina_medical_center/features/branches/data/repositories/branch_repository_impl.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/branches/domain/repositories/branch_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockBranchRemoteDataSource extends Mock
    implements BranchRemoteDataSource {}

void main() {
  late BranchRepositoryImpl repository;
  late MockBranchRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockBranchRemoteDataSource();
    repository = BranchRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tBranchModel = BranchModel(
    id: '1',
    name: 'Cardiology',
    shortName: 'Cardio',
    imageUrl: 'url',
  );

  final tBranchesModel = [tBranchModel];

  final List<BranchEntity> tBranchesEntity = tBranchesModel;

  group('BranchRepositoryImpl Tests', () {
    group('getAllBranches', () {
      test(
        'should return Right(List<BranchEntity>) when data source is successful',
        () async {
          when(
            () => mockRemoteDataSource.getAllBranches(),
          ).thenAnswer((_) async => tBranchesModel);

          final result = await repository.getAllBranches();

          verify(() => mockRemoteDataSource.getAllBranches()).called(1);

          expect(
            result,
            equals(Right<Failure, List<BranchEntity>>(tBranchesEntity)),
          );
        },
      );

      test(
        'should return ServerFailure when data source throws an error',
        () async {
          when(
            () => mockRemoteDataSource.getAllBranches(),
          ).thenThrow(ServerException(message: 'API Error'));

          final result = await repository.getAllBranches();

          verify(() => mockRemoteDataSource.getAllBranches()).called(1);
          expect(
            result,
            equals(
              const Left<Failure, List<BranchEntity>>(
                ServerFailure(debugMessage: 'API Error'),
              ),
            ),
          );
        },
      );
    });

    group('createBranch', () {
      final tParams = CreateBranchParams(
        name: 'Neurology',
        imageUrl: 'img.png',
      );
      const tCreatedModel = BranchModel(
        id: '2',
        name: 'Neurology',
        shortName: '',
        imageUrl: 'img.png',
      );

      test(
        'should return Right(BranchEntity) when creation is successful',
        () async {
          when(
            () => mockRemoteDataSource.createBranch(tParams.toMap()),
          ).thenAnswer((_) async => tCreatedModel);

          final result = await repository.createBranch(tParams);

          verify(
            () => mockRemoteDataSource.createBranch(tParams.toMap()),
          ).called(1);

          expect(
            result,
            equals(const Right<Failure, BranchEntity>(tCreatedModel)),
          );
        },
      );

      test('should return ServerFailure when creation fails', () async {
        when(
          () => mockRemoteDataSource.createBranch(any()),
        ).thenThrow(ServerException(message: 'Creation Failed'));

        final result = await repository.createBranch(tParams);

        expect(
          result,
          equals(
            const Left<Failure, BranchEntity>(
              ServerFailure(debugMessage: 'Creation Failed'),
            ),
          ),
        );
      });
    });
  });
}
