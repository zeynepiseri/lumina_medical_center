import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/data/datasources/doctor_profile_service.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/data/models/my_profile_model.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/data/repositories/doctor_dashboard_repository_impl.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/entities/my_profile_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorProfileService extends Mock implements DoctorProfileService {}

void main() {
  late DoctorDashboardRepositoryImpl repository;
  late MockDoctorProfileService mockService;

  setUp(() {
    mockService = MockDoctorProfileService();
    repository = DoctorDashboardRepositoryImpl(mockService);
  });

  const tUserId = 123;

  final tProfileModel = MyProfileModel(
    id: 1,
    fullName: 'Dr. Test',
    title: 'Prof.',
    branchName: 'Cardiology',
    biography: 'Bio',
    experience: 10,
    diplomaNo: '12345',
    email: 'test@test.com',
    phoneNumber: '555',
    nationalId: '111',
    imageUrl: 'url',
    schedules: const [],
    subSpecialties: const ['Heart'],
    educations: const ['School'],
    patientCount: 100,
  );

  final MyProfileEntity tProfileEntity = tProfileModel;

  group('DoctorDashboardRepositoryImpl Tests', () {
    group('getMyProfile', () {
      test(
        'If the service is successful, it should return Right(MyProfileEntity)',
        () async {
          when(
            () => mockService.getMyProfile(tUserId),
          ).thenAnswer((_) async => tProfileModel);

          final result = await repository.getMyProfile();

          verify(() => mockService.getMyProfile(tUserId)).called(1);
          expect(result, equals(Right(tProfileEntity)));
        },
      );

      test(
        'If the service gives an error, ServerFailure should return',
        () async {
          when(
            () => mockService.getMyProfile(tUserId),
          ).thenThrow(ServerException(message: 'Veri yok'));

          final result = await repository.getMyProfile();

          expect(
            result,
            equals(const Left(ServerFailure(debugMessage: 'Veri yok'))),
          );
        },
      );
    });

    group('updateProfile', () {
      const tBio = 'New Bio';
      const tExp = 15;
      const tSchedules = <WorkSchedule>[];
      const tSubs = ['Neuro'];
      const tEdus = ['PhD'];
      const tImg = 'new_url';

      test('If the service is successful, Right(void) should return', () async {
        when(
          () => mockService.updateProfile(
            userId: tUserId,
            biography: any(named: 'biography'),
            experience: any(named: 'experience'),
            schedules: any(named: 'schedules'),
            subSpecialties: any(named: 'subSpecialties'),
            educations: any(named: 'educations'),
            imageUrl: any(named: 'imageUrl'),
          ),
        ).thenAnswer((_) async => true);

        final result = await repository.updateProfile(
          biography: tBio,
          experience: tExp,
          schedules: tSchedules,
          subSpecialties: tSubs,
          educations: tEdus,
          imageUrl: tImg,
        );

        verify(
          () => mockService.updateProfile(
            userId: tUserId,
            biography: tBio,
            experience: tExp,
            schedules: any(named: 'schedules'),
            subSpecialties: tSubs,
            educations: tEdus,
            imageUrl: tImg,
          ),
        ).called(1);

        expect(result.isRight(), true);
      });

      test(
        'If the service gives an error, ServerFailure should return',
        () async {
          when(
            () => mockService.updateProfile(
              userId: any(named: 'userId'),
              biography: any(named: 'biography'),
              experience: any(named: 'experience'),
              schedules: any(named: 'schedules'),
              subSpecialties: any(named: 'subSpecialties'),
              educations: any(named: 'educations'),
              imageUrl: any(named: 'imageUrl'),
            ),
          ).thenThrow(ServerException(message: 'Update Failed'));

          final result = await repository.updateProfile(
            biography: tBio,
            experience: tExp,
            schedules: tSchedules,
            subSpecialties: tSubs,
            educations: tEdus,
            imageUrl: tImg,
          );

          expect(
            result,
            equals(const Left(ServerFailure(debugMessage: 'Update Failed'))),
          );
        },
      );
    });
  });
}
