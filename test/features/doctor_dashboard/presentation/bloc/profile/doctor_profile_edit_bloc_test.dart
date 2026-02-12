import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/entities/my_profile_entity.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/usecases/get_my_profile_usecase.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/usecases/update_my_profile_usecase.dart';

import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/profile/doctor_profile_edit_bloc.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/profile/doctor_profile_edit_event.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/profile/doctor_profile_edit_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMyProfileUseCase extends Mock implements GetMyProfileUseCase {}

class MockUpdateMyProfileUseCase extends Mock
    implements UpdateMyProfileUseCase {}

void main() {
  late DoctorProfileBloc doctorProfileBloc;
  late MockGetMyProfileUseCase mockGetMyProfileUseCase;
  late MockUpdateMyProfileUseCase mockUpdateMyProfileUseCase;

  final tProfile = MyProfileEntity(
    id: 1,
    fullName: 'Dr. Test',
    title: 'Prof.',
    branchName: 'Cardiology',
    biography: 'Old Bio',
    experience: 5,
    diplomaNo: '123',
    imageUrl: 'url',
    schedules: const [],
    subSpecialties: const ['A'],
    educations: const ['B'],
    patientCount: 50,
  );

  const tNewBio = "New Bio";
  const tNewExp = 10;

  setUpAll(() {
    registerFallbackValue(
      const UpdateProfileParams(
        biography: '',
        experience: 0,
        schedules: [],
        subSpecialties: [],
        educations: [],
      ),
    );
  });

  setUp(() {
    mockGetMyProfileUseCase = MockGetMyProfileUseCase();
    mockUpdateMyProfileUseCase = MockUpdateMyProfileUseCase();

    doctorProfileBloc = DoctorProfileBloc(
      getMyProfile: mockGetMyProfileUseCase,
      updateProfile: mockUpdateMyProfileUseCase,
    );
  });

  tearDown(() {
    doctorProfileBloc.close();
  });

  group('DoctorProfileBloc Tests', () {
    test('Initial state should be ProfileLoading', () {
      expect(doctorProfileBloc.state, isA<ProfileLoading>());
    });

    group('LoadProfileEvent', () {
      blocTest<DoctorProfileBloc, ProfileState>(
        '[ProfileLoading, ProfileLoaded] must be propagated on successful upload',
        build: () {
          when(
            () => mockGetMyProfileUseCase(),
          ).thenAnswer((_) async => Right(tProfile));
          return doctorProfileBloc;
        },
        act: (bloc) => bloc.add(LoadProfileEvent()),
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileLoaded>().having((s) => s.profile, 'profile', tProfile),
        ],
        verify: (_) {
          verify(() => mockGetMyProfileUseCase()).called(1);
        },
      );

      blocTest<DoctorProfileBloc, ProfileState>(
        'In case of error, [ProfileLoading, ProfileError] should be emitted.',
        build: () {
          when(() => mockGetMyProfileUseCase()).thenAnswer(
            (_) async => const Left(ServerFailure(debugMessage: 'Error')),
          );
          return doctorProfileBloc;
        },
        act: (bloc) => bloc.add(LoadProfileEvent()),
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileError>().having((s) => s.message, 'message', 'Error'),
        ],
      );
    });

    group('UpdateProfileEvent', () {
      blocTest<DoctorProfileBloc, ProfileState>(
        'In a successful update, update statuses should propagate followed by reinstallation statuses.',
        build: () {
          when(
            () => mockGetMyProfileUseCase(),
          ).thenAnswer((_) async => Right(tProfile));

          when(
            () => mockUpdateMyProfileUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return doctorProfileBloc;
        },
        act: (bloc) async {
          bloc.add(LoadProfileEvent());

          bloc.add(
            const UpdateProfileEvent(
              biography: tNewBio,
              experience: tNewExp,
              schedules: [],
              subSpecialties: [],
              educations: [],
            ),
          );
        },
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileLoaded>(),
          isA<ProfileUpdating>(),
          isA<ProfileUpdateSuccess>(),

          isA<ProfileLoading>(),
          isA<ProfileLoaded>(),
        ],
        verify: (_) {
          verify(
            () => mockUpdateMyProfileUseCase(
              any(
                that: isA<UpdateProfileParams>()
                    .having((p) => p.biography, 'bio', tNewBio)
                    .having((p) => p.experience, 'exp', tNewExp),
              ),
            ),
          ).called(1);

          verify(() => mockGetMyProfileUseCase()).called(2);
        },
      );

      blocTest<DoctorProfileBloc, ProfileState>(
        'If the update fails, Error should be displayed and the old profile should be reapplied.',
        build: () {
          when(
            () => mockGetMyProfileUseCase(),
          ).thenAnswer((_) async => Right(tProfile));
          when(() => mockUpdateMyProfileUseCase(any())).thenAnswer(
            (_) async => const Left(ServerFailure(debugMessage: 'Save Failed')),
          );
          return doctorProfileBloc;
        },
        act: (bloc) {
          bloc.add(LoadProfileEvent());
          bloc.add(
            const UpdateProfileEvent(
              biography: tNewBio,
              experience: tNewExp,
              schedules: [],
              subSpecialties: [],
              educations: [],
            ),
          );
        },
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileLoaded>(),
          isA<ProfileUpdating>(),
          isA<ProfileError>().having(
            (s) => s.message,
            'message',
            contains('Save Failed'),
          ),
          isA<ProfileLoaded>(),
        ],
      );
    });
  });
}
