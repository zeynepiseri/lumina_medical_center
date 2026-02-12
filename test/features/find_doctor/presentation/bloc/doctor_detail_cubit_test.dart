import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/usecases/get_doctor_detail_usecase.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/bloc/doctor_detail_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDoctorDetailUseCase extends Mock
    implements GetDoctorDetailUseCase {}

void main() {
  late DoctorDetailCubit doctorDetailCubit;
  late MockGetDoctorDetailUseCase mockGetDoctorDetailUseCase;

  setUp(() {
    mockGetDoctorDetailUseCase = MockGetDoctorDetailUseCase();
    doctorDetailCubit = DoctorDetailCubit(mockGetDoctorDetailUseCase);
  });

  tearDown(() {
    doctorDetailCubit.close();
  });

  const tDoctorId = 1;
  const tDoctor = DoctorEntity(
    id: 1,
    fullName: 'Dr. House',
    specialty: 'Diagnostic',
    imageUrl: 'url',
    title: 'MD',
    biography: 'Bio',
    branchName: 'Internal Medicine',
  );

  group('DoctorDetailCubit Tests', () {
    test('Initial state should be DoctorDetailStatus.initial', () {
      expect(
        doctorDetailCubit.state.status,
        equals(DoctorDetailStatus.initial),
      );
    });

    blocTest<DoctorDetailCubit, DoctorDetailState>(
      'When loadDoctor runs successfully, [loading, success] should be emitted.',
      build: () {
        when(
          () => mockGetDoctorDetailUseCase(tDoctorId),
        ).thenAnswer((_) async => const Right(tDoctor));
        return doctorDetailCubit;
      },
      act: (cubit) => cubit.loadDoctor(tDoctorId),
      expect: () => [
        const DoctorDetailState(status: DoctorDetailStatus.loading),

        const DoctorDetailState(
          status: DoctorDetailStatus.success,
          doctor: tDoctor,
        ),
      ],
      verify: (_) {
        verify(() => mockGetDoctorDetailUseCase(tDoctorId)).called(1);
      },
    );

    blocTest<DoctorDetailCubit, DoctorDetailState>(
      '[loading, failure] should be propagated when the loadDoctor receives an error',
      build: () {
        when(() => mockGetDoctorDetailUseCase(tDoctorId)).thenAnswer(
          (_) async => const Left(ServerFailure(debugMessage: 'Not Found')),
        );
        return doctorDetailCubit;
      },
      act: (cubit) => cubit.loadDoctor(tDoctorId),
      expect: () => [
        const DoctorDetailState(status: DoctorDetailStatus.loading),
        const DoctorDetailState(
          status: DoctorDetailStatus.failure,
          errorMessage: 'Not Found',
        ),
      ],
    );

    blocTest<DoctorDetailCubit, DoctorDetailState>(
      'The isFavorite value should be reversed when toggleFavorite is called',
      build: () => doctorDetailCubit,
      act: (cubit) {
        cubit.toggleFavorite();
        cubit.toggleFavorite();
      },
      expect: () => [
        const DoctorDetailState(isFavorite: true),
        const DoctorDetailState(isFavorite: false),
      ],
    );
  });
}
