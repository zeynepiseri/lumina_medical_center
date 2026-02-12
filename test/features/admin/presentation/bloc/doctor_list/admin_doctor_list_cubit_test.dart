import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';
import 'package:lumina_medical_center/features/admin/domain/usecases/get_all_doctors_usecase.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_doctor_list/admin_doctor_list_cubit.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_doctor_list/admin_doctor_list_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllDoctorsUseCase extends Mock implements GetAllDoctorsUseCase {}

void main() {
  late AdminDoctorListCubit cubit;
  late MockGetAllDoctorsUseCase mockGetAllDoctorsUseCase;

  const tDoctor1 = AdminDoctorEntity(
    id: 1,
    fullName: 'Ali Yilmaz',
    specialty: 'Cardiology',
    title: 'Dr.',
    imageUrl: '',
    biography: '',
    experience: 5,
    patientCount: 100,
    rating: 4.5,
    reviewCount: 10,
    email: '',
    phoneNumber: '',
    nationalId: '',
    gender: '',
    diplomaNo: '',
    birthDate: '',
    subSpecialties: [],
    professionalExperiences: [],
    educations: [],
    acceptedInsurances: [],
    schedules: [],
  );

  const tDoctor2 = AdminDoctorEntity(
    id: 2,
    fullName: 'Zeynep Kaya',
    specialty: 'Neurology',
    title: 'Prof.',
    imageUrl: '',
    biography: '',
    experience: 10,
    patientCount: 200,
    rating: 4.8,
    reviewCount: 20,
    email: '',
    phoneNumber: '',
    nationalId: '',
    gender: '',
    diplomaNo: '',
    birthDate: '',
    subSpecialties: [],
    professionalExperiences: [],
    educations: [],
    acceptedInsurances: [],
    schedules: [],
  );

  final tDoctorList = [tDoctor1, tDoctor2];

  setUp(() {
    mockGetAllDoctorsUseCase = MockGetAllDoctorsUseCase();
    cubit = AdminDoctorListCubit(mockGetAllDoctorsUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('AdminDoctorListCubit', () {
    test('Initial state should be correct', () {
      expect(cubit.state.status, DoctorListStatus.initial);
      expect(cubit.state.allDoctors, isEmpty);
    });

    blocTest<AdminDoctorListCubit, AdminDoctorListState>(
      'Should load entire list when loadDoctors is successful',
      build: () {
        when(
          () => mockGetAllDoctorsUseCase(),
        ).thenAnswer((_) async => Right(tDoctorList));
        return cubit;
      },
      act: (cubit) => cubit.loadDoctors(),
      expect: () => [
        isA<AdminDoctorListState>().having(
          (s) => s.status,
          'status',
          DoctorListStatus.loading,
        ),
        isA<AdminDoctorListState>()
            .having((s) => s.status, 'status', DoctorListStatus.success)
            .having((s) => s.allDoctors.length, 'allDoctors count', 2)
            .having(
              (s) => s.filteredDoctors.length,
              'filteredDoctors count',
              2,
            ),
      ],
    );

    blocTest<AdminDoctorListCubit, AdminDoctorListState>(
      'Should return Failure when loadDoctors receives an error',
      build: () {
        when(() => mockGetAllDoctorsUseCase()).thenAnswer(
          (_) async => const Left(ServerFailure(debugMessage: 'Error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadDoctors(),
      expect: () => [
        isA<AdminDoctorListState>().having(
          (s) => s.status,
          'status',
          DoctorListStatus.loading,
        ),
        isA<AdminDoctorListState>().having(
          (s) => s.status,
          'status',
          DoctorListStatus.failure,
        ),
      ],
    );

    group('Search / Filtering (Client-Side Logic)', () {
      final loadedState = AdminDoctorListState(
        status: DoctorListStatus.success,
        allDoctors: tDoctorList,
        filteredDoctors: tDoctorList,
      );

      blocTest<AdminDoctorListCubit, AdminDoctorListState>(
        'Should return only Ali when searching for "Ali"',
        build: () => cubit,
        seed: () => loadedState,
        act: (cubit) => cubit.filterDoctors('Ali'),
        expect: () => [
          isA<AdminDoctorListState>()
              .having((s) => s.filteredDoctors.length, 'Filtered Count', 1)
              .having(
                (s) => s.filteredDoctors.first.fullName,
                'Name',
                'Ali Yilmaz',
              ),
        ],
      );

      blocTest<AdminDoctorListCubit, AdminDoctorListState>(
        'Should return entire list when search box is cleared (empty string)',
        build: () => cubit,
        seed: () => loadedState.copyWith(filteredDoctors: [tDoctor1]),
        act: (cubit) => cubit.filterDoctors(''),
        expect: () => [
          isA<AdminDoctorListState>().having(
            (s) => s.filteredDoctors.length,
            'All',
            2,
          ),
        ],
      );

      blocTest<AdminDoctorListCubit, AdminDoctorListState>(
        'Should be case insensitive (ali = Ali)',
        build: () => cubit,
        seed: () => loadedState,
        act: (cubit) => cubit.filterDoctors('ali'),
        expect: () => [
          isA<AdminDoctorListState>()
              .having((s) => s.filteredDoctors.length, 'Found', 1)
              .having(
                (s) => s.filteredDoctors.first.fullName,
                'Name',
                'Ali Yilmaz',
              ),
        ],
      );
    });
  });
}
