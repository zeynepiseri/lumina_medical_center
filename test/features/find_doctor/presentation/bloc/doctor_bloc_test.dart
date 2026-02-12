import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/usecases/get_doctors_usecase.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/bloc/doctor_bloc.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/bloc/doctor_event.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/bloc/doctor_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDoctorsUseCase extends Mock implements GetDoctorsUseCase {}

void main() {
  late DoctorBloc doctorBloc;
  late MockGetDoctorsUseCase mockGetDoctorsUseCase;

  setUp(() {
    mockGetDoctorsUseCase = MockGetDoctorsUseCase();
    doctorBloc = DoctorBloc(mockGetDoctorsUseCase);
  });

  tearDown(() {
    doctorBloc.close();
  });

  const tBranchId = '1';
  final tDoctors = [
    const DoctorEntity(
      id: 1,
      fullName: 'Dr. House',
      specialty: 'Diagnostic',
      imageUrl: 'url',
      title: 'MD',
      branchName: 'Internal Medicine',
    ),
  ];

  group('DoctorBloc Tests', () {
    test('Initial state should be DoctorInitial', () {
      expect(doctorBloc.state, equals(DoctorInitial()));
    });

    blocTest<DoctorBloc, DoctorState>(
      'Should emit [DoctorLoading, DoctorLoaded] when data is fetched successfully',
      build: () {
        when(
          () => mockGetDoctorsUseCase(branchId: tBranchId),
        ).thenAnswer((_) async => Right(tDoctors));
        return doctorBloc;
      },
      act: (bloc) => bloc.add(const LoadDoctors(branchId: tBranchId)),
      expect: () => [DoctorLoading(), DoctorLoaded(tDoctors)],
      verify: (_) {
        verify(() => mockGetDoctorsUseCase(branchId: tBranchId)).called(1);
      },
    );

    blocTest<DoctorBloc, DoctorState>(
      'Should emit [DoctorLoading, DoctorError] when fetching fails',
      build: () {
        when(() => mockGetDoctorsUseCase(branchId: tBranchId)).thenAnswer(
          (_) async => const Left(ServerFailure(debugMessage: 'API Error')),
        );
        return doctorBloc;
      },
      act: (bloc) => bloc.add(const LoadDoctors(branchId: tBranchId)),
      expect: () => [DoctorLoading(), const DoctorError('API Error')],
    );
  });
}
