import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/patient/data/datasources/patient_remote_datasource.dart';
import 'package:lumina_medical_center/features/patient/data/models/patient_model.dart';
import 'package:lumina_medical_center/features/patient/data/repositories/patient_repository_impl.dart';
import 'package:lumina_medical_center/features/patient/domain/entities/patient_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockPatientRemoteDataSource extends Mock
    implements PatientRemoteDataSource {}

void main() {
  late PatientRepositoryImpl repository;
  late MockPatientRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockPatientRemoteDataSource();
    repository = PatientRepositoryImpl(mockRemoteDataSource);
  });

  const tPatientModel = PatientModel(
    id: 1,
    fullName: 'Test User',
    email: 'test@test.com',
    height: 170,
    weight: 70,
    bloodType: 'A+',
    allergies: [],
    chronicDiseases: [],
  );

  final PatientEntity tPatientEntity = tPatientModel;

  group('PatientRepositoryImpl Tests', () {
    test(
      'getPatientProfile should return Right<PatientEntity> on success',
      () async {
        when(
          () => mockRemoteDataSource.getCurrentPatient(),
        ).thenAnswer((_) async => tPatientModel);

        final result = await repository.getPatientProfile();

        expect(result, equals(Right<Failure, PatientEntity>(tPatientEntity)));
      },
    );

    test(
      'getPatientProfile should return Left<ServerFailure> on exception',
      () async {
        when(
          () => mockRemoteDataSource.getCurrentPatient(),
        ).thenThrow(Exception('Error'));

        final result = await repository.getPatientProfile();

        expect(result.isLeft(), true);
      },
    );

    test('updatePatientVitals should return Right<void> on success', () async {
      when(
        () => mockRemoteDataSource.updateVitals(any()),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.updatePatientVitals(
        height: 170,
        weight: 70,
      );

      expect(result, equals(const Right<Failure, void>(null)));
    });
  });
}
