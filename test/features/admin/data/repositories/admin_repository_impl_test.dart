import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/admin/data/datasources/admin_service.dart';
import 'package:lumina_medical_center/features/admin/data/models/admin_doctor_model.dart';
import 'package:lumina_medical_center/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:lumina_medical_center/features/admin/domain/usecases/add_doctor_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAdminService extends Mock implements AdminService {}

void main() {
  late AdminRepositoryImpl repository;
  late MockAdminService mockAdminService;

  setUp(() {
    mockAdminService = MockAdminService();
    repository = AdminRepositoryImpl(mockAdminService);
  });

  group('AdminRepositoryImpl', () {
    /* * SCENARIO 1: getAllDoctors
     * Purpose: Does the JSON list from the API correctly convert to the 
     * Entity list used by the UI?
     */
    group('getAllDoctors', () {
      final tDoctorList = [
        const AdminDoctorModel(
          id: 1,
          fullName: 'Dr. Test',
          title: 'Prof.',
          specialty: 'Cardiology',
          imageUrl: 'url',
          biography: 'Bio',
          experience: 10,
          patientCount: 100,
          rating: 4.5,
          reviewCount: 10,
          email: 'test@doc.com',
          phoneNumber: '123456',
          nationalId: '111',
          gender: 'Male',
          diplomaNo: 'DIP123',
          birthDate: '1980',
          subSpecialties: [],
          professionalExperiences: [],
          educations: [],
          acceptedInsurances: [],
          schedules: [],
        ),
      ];

      test(
        'Should return Doctor list when service is successful (Right)',
        () async {
          when(
            () => mockAdminService.getAllDoctors(),
          ).thenAnswer((_) async => tDoctorList);

          final result = await repository.getAllDoctors();

          verify(() => mockAdminService.getAllDoctors()).called(1);
          expect(result.isRight(), true);
          result.fold((failure) => fail('Error was not expected'), (doctors) {
            expect(doctors.length, 1);
            expect(doctors.first.fullName, 'Dr. Test');
          });
        },
      );

      test(
        'Should return ServerFailure when service gives an error (Left)',
        () async {
          when(
            () => mockAdminService.getAllDoctors(),
          ).thenThrow(ServerException(message: 'Data could not be fetched'));

          final result = await repository.getAllDoctors();

          expect(
            result,
            equals(
              const Left(
                ServerFailure(debugMessage: 'Data could not be fetched'),
              ),
            ),
          );
        },
      );
    });

    /* * SCENARIO 2: addDoctor
     * Purpose: Are parameters (Params) from UI transmitted to the service 
     * as a correct Map (JSON)? Mapper test is implicitly done here.
     */
    group('addDoctor', () {
      const tAddParams = AddDoctorParams(
        fullName: 'New Doctor',
        title: 'Assoc.',
        specialty: 'Neurology',
        specialtyId: 2,
        imageUrl: 'img.png',
        biography: 'New Bio',
        branchId: 1,
        experience: 5,
        patients: '500',
        reviews: '0',
        email: 'new@doc.com',
        nationalId: '999',
        phoneNumber: '555',
        gender: 'Female',
        diplomaNo: 'DIP999',
        acceptedInsurances: ['Allianz'],
        subSpecialties: [],
        professionalExperiences: [],
        educations: [],
        schedules: [],
        password: 'pass',
      );

      test('Should return Void when service is successful (Success)', () async {
        when(
          () => mockAdminService.addDoctor(any()),
        ).thenAnswer((_) async => Future.value());

        final result = await repository.addDoctor(tAddParams);

        verify(
          () => mockAdminService.addDoctor(
            any(
              that: isA<Map<String, dynamic>>().having(
                (map) => map['fullName'],
                'fullName',
                'New Doctor',
              ),
            ),
          ),
        ).called(1);

        expect(result, equals(const Right(null)));
      });

      test('Should return ServerFailure when service gives an error', () async {
        when(
          () => mockAdminService.addDoctor(any()),
        ).thenThrow(ServerException(message: 'Email in use'));

        final result = await repository.addDoctor(tAddParams);

        expect(
          result,
          equals(const Left(ServerFailure(debugMessage: 'Email in use'))),
        );
      });
    });
  });
}
