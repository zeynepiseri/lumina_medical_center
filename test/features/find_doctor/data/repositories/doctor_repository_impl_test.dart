import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/find_doctor/data/datasources/doctor_service.dart';
import 'package:lumina_medical_center/features/find_doctor/data/models/doctor_model.dart';
import 'package:lumina_medical_center/features/find_doctor/data/repositories/doctor_repository.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorService extends Mock implements DoctorService {}

void main() {
  late DoctorRepositoryImpl repository;
  late MockDoctorService mockService;

  setUp(() {
    mockService = MockDoctorService();
    repository = DoctorRepositoryImpl(mockService);
  });

  const tBranchId = '1';

  final tDoctorModel = DoctorModel(
    id: 1,
    fullName: 'Dr. Test',
    specialty: 'Cardio',
    imageUrl: 'url',
    title: 'Prof.',
    branchName: 'Cardiology',
    biography: 'Experienced cardiologist.',
    rating: 4.5,
    reviewCount: 10,
    patientCount: 100,
    experience: 5,
    consultationFee: 200,
    subSpecialties: const [],
    professionalExperiences: const [],
    educations: const [],
    certificates: const [],
    languages: const [],
    acceptedInsurances: const [],
    schedules: const [],
  );

  final List<DoctorEntity> tDoctorEntities = [tDoctorModel];
  final List<DoctorModel> tDoctorModels = [tDoctorModel];

  group('DoctorRepositoryImpl Tests', () {
    test(
      'getDoctors should return List<DoctorEntity> when service call is successful',
      () async {
        when(
          () => mockService.getDoctors(branchId: tBranchId),
        ).thenAnswer((_) async => tDoctorModels);

        final result = await repository.getDoctors(branchId: tBranchId);

        verify(() => mockService.getDoctors(branchId: tBranchId)).called(1);

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Test failed: Expected Right, got Left'),
          (doctors) => expect(doctors, equals(tDoctorEntities)),
        );
      },
    );

    test(
      'getDoctors should return ServerFailure when service throws an exception',
      () async {
        when(
          () => mockService.getDoctors(branchId: tBranchId),
        ).thenThrow(Exception('Network Error'));

        final result = await repository.getDoctors(branchId: tBranchId);

        expect(
          result,
          equals(
            const Left<Failure, List<DoctorEntity>>(
              ServerFailure(debugMessage: 'Exception: Network Error'),
            ),
          ),
        );
      },
    );
  });
}
