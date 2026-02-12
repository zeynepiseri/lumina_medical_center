import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/admin/domain/usecases/add_doctor_usecase.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_add_doctor/admin_add_doctor_cubit.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_add_doctor/admin_add_doctor_state.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/branches/domain/usecases/get_all_branches_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAddDoctorUseCase extends Mock implements AddDoctorUseCase {}

class MockGetAllBranchesUseCase extends Mock implements GetAllBranchesUseCase {}

void main() {
  late AddDoctorCubit cubit;
  late MockAddDoctorUseCase mockAddDoctorUseCase;
  late MockGetAllBranchesUseCase mockGetAllBranchesUseCase;

  final tBranch = BranchEntity(
    id: '1',
    name: 'Cardiology',
    shortName: 'Cardio',
    imageUrl: 'url',
  );

  final tBranchList = [tBranch];
  const tServerFailure = ServerFailure(debugMessage: 'API Error');

  setUpAll(() {
    registerFallbackValue(
      const AddDoctorParams(
        fullName: '',
        title: '',
        specialty: '',
        specialtyId: 0,
        imageUrl: '',
        biography: '',
        branchId: 0,
        experience: 0,
        patients: '',
        reviews: '',
        email: '',
        nationalId: '',
        phoneNumber: '',
        gender: '',
        diplomaNo: '',
        acceptedInsurances: [],
        subSpecialties: [],
        professionalExperiences: [],
        educations: [],
        schedules: [],
        password: '',
      ),
    );
  });

  setUp(() {
    mockAddDoctorUseCase = MockAddDoctorUseCase();
    mockGetAllBranchesUseCase = MockGetAllBranchesUseCase();

    when(
      () => mockGetAllBranchesUseCase(),
    ).thenAnswer((_) async => Right(tBranchList));

    cubit = AddDoctorCubit(
      addDoctorUseCase: mockAddDoctorUseCase,
      getAllBranchesUseCase: mockGetAllBranchesUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('AddDoctorCubit Tests', () {
    test(
      'Initial state should be correct and constructor should load branches',
      () async {
        await Future.delayed(Duration.zero);
        expect(cubit.state.status, AddDoctorStatus.initial);
        expect(cubit.state.branches, equals(tBranchList));
        verify(() => mockGetAllBranchesUseCase()).called(1);
      },
    );

    group('Form Field Updates', () {
      blocTest<AddDoctorCubit, AddDoctorState>(
        'fullNameChanged should update state',
        build: () => cubit,
        act: (cubit) => cubit.fullNameChanged('Dr. House'),
        expect: () => [
          isA<AddDoctorState>().having(
            (s) => s.fullName,
            'fullName',
            'Dr. House',
          ),
        ],
      );

      blocTest<AddDoctorCubit, AddDoctorState>(
        'branchChanged should update selected branch and specialty',
        build: () => cubit,
        act: (cubit) {
          cubit.branchChanged('1');
        },
        expect: () => [
          isA<AddDoctorState>()
              .having((s) => s.selectedBranchId, 'selectedBranchId', '1')
              .having((s) => s.specialty, 'specialty', 'Cardiology'),
        ],
      );
    });

    group('submitForm', () {
      blocTest<AddDoctorCubit, AddDoctorState>(
        'Should emit Failure if required fields are empty (Validation Test)',
        build: () => cubit,
        act: (cubit) => cubit.submitForm(),
        expect: () => [
          isA<AddDoctorState>()
              .having((s) => s.status, 'status', AddDoctorStatus.failure)
              .having((s) => s.failure, 'failure', isA<UnknownFailure>()),
        ],
      );

      blocTest<AddDoctorCubit, AddDoctorState>(
        'Should emit [Loading, Success] if everything is correct',
        build: () {
          when(
            () => mockAddDoctorUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) async {
          cubit.fullNameChanged('Dr. Ali');
          cubit.emailChanged('ali@test.com');
          cubit.passwordChanged('123456');
          cubit.branchChanged('1');

          await cubit.submitForm();
        },
        expect: () => [
          isA<AddDoctorState>().having(
            (s) => s.fullName,
            'fullName',
            'Dr. Ali',
          ),
          isA<AddDoctorState>().having((s) => s.email, 'email', 'ali@test.com'),
          isA<AddDoctorState>().having((s) => s.password, 'password', '123456'),
          isA<AddDoctorState>().having(
            (s) => s.selectedBranchId,
            'branch',
            '1',
          ),
          isA<AddDoctorState>().having(
            (s) => s.status,
            'status',
            AddDoctorStatus.loading,
          ),
          isA<AddDoctorState>().having(
            (s) => s.status,
            'status',
            AddDoctorStatus.success,
          ),
        ],
        verify: (_) {
          verify(() => mockAddDoctorUseCase(any())).called(1);
        },
      );

      blocTest<AddDoctorCubit, AddDoctorState>(
        'Should emit [Loading, Failure] in case of API error',
        build: () {
          when(
            () => mockAddDoctorUseCase(any()),
          ).thenAnswer((_) async => const Left(tServerFailure));
          return cubit;
        },
        act: (cubit) async {
          cubit.fullNameChanged('Dr. Ali');
          cubit.emailChanged('ali@test.com');
          cubit.passwordChanged('123456');
          cubit.branchChanged('1');
          await cubit.submitForm();
        },
        expect: () => [
          isA<AddDoctorState>(),
          isA<AddDoctorState>(),
          isA<AddDoctorState>(),
          isA<AddDoctorState>(),
          isA<AddDoctorState>().having(
            (s) => s.status,
            'status',
            AddDoctorStatus.loading,
          ),
          isA<AddDoctorState>()
              .having((s) => s.status, 'status', AddDoctorStatus.failure)
              .having((s) => s.failure, 'failure', tServerFailure),
        ],
      );
    });
  });
}
