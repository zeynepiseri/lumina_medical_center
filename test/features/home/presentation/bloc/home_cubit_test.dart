import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/get_upcoming_appointment_usecase.dart';
import 'package:lumina_medical_center/features/auth/domain/entities/user_entity.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/branches/domain/usecases/get_all_branches_usecase.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/usecases/get_top_doctors_usecase.dart';
import 'package:lumina_medical_center/features/home/presentation/bloc/home_cubit.dart';
import 'package:lumina_medical_center/features/home/presentation/bloc/home_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTopDoctorsUseCase extends Mock implements GetTopDoctorsUseCase {}

class MockGetUpcomingAppointmentUseCase extends Mock
    implements GetUpcomingAppointmentUseCase {}

class MockGetUserUseCase extends Mock implements GetUserUseCase {}

class MockGetAllBranchesUseCase extends Mock implements GetAllBranchesUseCase {}

class MockUserEntity extends Mock implements UserEntity {}

class MockAppointmentEntity extends Mock implements AppointmentEntity {}

void main() {
  late HomeCubit homeCubit;
  late MockGetTopDoctorsUseCase mockGetTopDoctorsUseCase;
  late MockGetUpcomingAppointmentUseCase mockGetUpcomingAppointmentUseCase;
  late MockGetUserUseCase mockGetUserUseCase;
  late MockGetAllBranchesUseCase mockGetAllBranchesUseCase;

  setUp(() {
    mockGetTopDoctorsUseCase = MockGetTopDoctorsUseCase();
    mockGetUpcomingAppointmentUseCase = MockGetUpcomingAppointmentUseCase();
    mockGetUserUseCase = MockGetUserUseCase();
    mockGetAllBranchesUseCase = MockGetAllBranchesUseCase();

    homeCubit = HomeCubit(
      getTopDoctorsUseCase: mockGetTopDoctorsUseCase,
      getUpcomingAppointmentUseCase: mockGetUpcomingAppointmentUseCase,
      getUserUseCase: mockGetUserUseCase,
      getAllBranchesUseCase: mockGetAllBranchesUseCase,
    );
  });

  tearDown(() {
    homeCubit.close();
  });

  final tUser = MockUserEntity();
  when(() => tUser.fullName).thenReturn('John Doe');
  when(() => tUser.imageUrl).thenReturn('user_url');

  final tDoctors = [
    const DoctorEntity(
      id: 1,
      fullName: 'Dr. House',
      specialty: 'Diagnostic',
      imageUrl: 'doc_url',
      title: 'MD',
      branchName: 'Internal',
    ),
    const DoctorEntity(
      id: 2,
      fullName: 'Dr. Strange',
      specialty: 'Surgery',
      imageUrl: 'doc_url_2',
      title: 'MD',
      branchName: 'Surgery',
    ),
  ];

  final tBranches = [
    const BranchEntity(
      id: '1',
      name: 'Cardio',
      shortName: 'Cardio',
      imageUrl: '',
    ),
  ];

  final tAppointment = MockAppointmentEntity();

  group('HomeCubit Tests', () {
    test('Initial state should be HomeStatus.initial', () {
      expect(homeCubit.state.status, equals(HomeStatus.initial));
    });

    blocTest<HomeCubit, HomeState>(
      'When loadHomeData runs successfully, success should be propagated along with all the data',
      build: () {
        when(
          () => mockGetTopDoctorsUseCase(),
        ).thenAnswer((_) async => Right(tDoctors));
        when(
          () => mockGetUpcomingAppointmentUseCase(),
        ).thenAnswer((_) async => Right(tAppointment));
        when(() => mockGetUserUseCase()).thenAnswer((_) async => Right(tUser));
        when(
          () => mockGetAllBranchesUseCase(),
        ).thenAnswer((_) async => Right(tBranches));
        return homeCubit;
      },
      act: (cubit) => cubit.loadHomeData(),
      expect: () => [
        const HomeState(status: HomeStatus.loading),

        isA<HomeState>()
            .having((s) => s.status, 'status', HomeStatus.success)
            .having((s) => s.userName, 'userName', 'John Doe')
            .having((s) => s.topDoctors.length, 'doctors count', 2)
            .having((s) => s.categories.length, 'categories count', 1)
            .having((s) => s.upcomingAppointment, 'appointment', isNotNull),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'Failure should spread if critical data (Doctors or Branches) does not arrive',
      build: () {
        when(() => mockGetTopDoctorsUseCase()).thenAnswer(
          (_) async => const Left(ServerFailure(debugMessage: 'API Error')),
        );

        when(
          () => mockGetUpcomingAppointmentUseCase(),
        ).thenAnswer((_) async => Right(null));
        when(() => mockGetUserUseCase()).thenAnswer((_) async => Right(tUser));
        when(
          () => mockGetAllBranchesUseCase(),
        ).thenAnswer((_) async => Right(tBranches));
        return homeCubit;
      },
      act: (cubit) => cubit.loadHomeData(),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        isA<HomeState>()
            .having((s) => s.status, 'status', HomeStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', isNotEmpty),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'the search function should filter the doctor list',
      build: () {
        when(
          () => mockGetTopDoctorsUseCase(),
        ).thenAnswer((_) async => Right(tDoctors));
        when(
          () => mockGetUpcomingAppointmentUseCase(),
        ).thenAnswer((_) async => Right(null));
        when(() => mockGetUserUseCase()).thenAnswer((_) async => Right(tUser));
        when(
          () => mockGetAllBranchesUseCase(),
        ).thenAnswer((_) async => Right(tBranches));
        return homeCubit;
      },
      seed: () => HomeState(
        status: HomeStatus.success,
        topDoctors: tDoctors,
        userName: 'John Doe',
      ),
      act: (cubit) async {
        await cubit.loadHomeData();
        cubit.search('House');
      },

      skip: 2,
      expect: () => [
        isA<HomeState>()
            .having((s) => s.searchQuery, 'query', 'House')
            .having((s) => s.topDoctors.length, 'filtered count', 1)
            .having(
              (s) => s.topDoctors.first.fullName,
              'doctor name',
              'Dr. House',
            ),
      ],
    );
  });
}
