import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:lumina_medical_center/features/auth/data/models/user_model.dart';
import 'package:lumina_medical_center/features/auth/data/repositories/user_repository_impl.dart';
import 'package:lumina_medical_center/features/auth/domain/entities/user_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

void main() {
  late UserRepositoryImpl repository;
  late MockUserRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    repository = UserRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tUserModel = UserModel(
    id: 1,
    email: 'test@test.com',
    fullName: 'Test User',
    role: 'patient',
    nationalId: '111',
    phoneNumber: '555',
    gender: 'Female',
    birthDate: '1990-01-01',
    imageUrl: 'url',
  );

  final UserEntity tUserEntity = tUserModel;

  group('UserRepositoryImpl Tests', () {
    group('getCurrentUser', () {
      test('should return Right(UserEntity) on success', () async {
        when(
          () => mockRemoteDataSource.getCurrentUser(),
        ).thenAnswer((_) async => tUserModel);

        final result = await repository.getCurrentUser();

        verify(() => mockRemoteDataSource.getCurrentUser()).called(1);
        expect(result, equals(Right(tUserEntity)));
      });

      test('should return ServerFailure in case of API error', () async {
        when(
          () => mockRemoteDataSource.getCurrentUser(),
        ).thenThrow(ServerException(message: 'User not found'));

        final result = await repository.getCurrentUser();

        expect(
          result,
          equals(const Left(ServerFailure(debugMessage: 'User not found'))),
        );
      });
    });

    group('updateProfilePhoto', () {
      const tPath = 'path/to/image.jpg';

      test('should return Right(bool) on success', () async {
        when(
          () => mockRemoteDataSource.updateProfilePhoto(tPath),
        ).thenAnswer((_) async => true);

        final result = await repository.updateProfilePhoto(tPath);

        verify(() => mockRemoteDataSource.updateProfilePhoto(tPath)).called(1);
        expect(result, equals(const Right(true)));
      });

      test('should return ServerFailure on failure', () async {
        when(
          () => mockRemoteDataSource.updateProfilePhoto(tPath),
        ).thenThrow(ServerException(message: 'Upload failed'));

        final result = await repository.updateProfilePhoto(tPath);

        expect(
          result,
          equals(const Left(ServerFailure(debugMessage: 'Upload failed'))),
        );
      });
    });

    group('changePassword', () {
      const tCurrent = 'oldPass';
      const tNew = 'newPass';

      test('should return Right(void) on success', () async {
        when(
          () => mockRemoteDataSource.changePassword(tCurrent, tNew),
        ).thenAnswer((_) async => {});

        final result = await repository.changePassword(tCurrent, tNew);

        verify(
          () => mockRemoteDataSource.changePassword(tCurrent, tNew),
        ).called(1);
        expect(result.isRight(), true);
      });

      test('should return ServerFailure on failure', () async {
        when(
          () => mockRemoteDataSource.changePassword(tCurrent, tNew),
        ).thenThrow(ServerException(message: 'Wrong password'));

        final result = await repository.changePassword(tCurrent, tNew);

        expect(
          result,
          equals(const Left(ServerFailure(debugMessage: 'Wrong password'))),
        );
      });
    });
  });
}
