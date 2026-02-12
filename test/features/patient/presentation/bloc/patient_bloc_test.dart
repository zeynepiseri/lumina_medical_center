import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/patient/domain/entities/patient_entity.dart';
import 'package:lumina_medical_center/features/patient/domain/usecases/get_patient_profile_usecase.dart';
import 'package:lumina_medical_center/features/patient/domain/usecases/update_patient_vitals_usecase.dart';
import 'package:lumina_medical_center/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPatientProfileUseCase extends Mock
    implements GetPatientProfileUseCase {}

class MockUpdatePatientVitalsUseCase extends Mock
    implements UpdatePatientVitalsUseCase {}

void main() {
  late PatientBloc patientBloc;
  late MockGetPatientProfileUseCase mockGetPatientProfileUseCase;
  late MockUpdatePatientVitalsUseCase mockUpdatePatientVitalsUseCase;

  setUp(() {
    mockGetPatientProfileUseCase = MockGetPatientProfileUseCase();
    mockUpdatePatientVitalsUseCase = MockUpdatePatientVitalsUseCase();

    registerFallbackValue(const UpdatePatientVitalsParams());

    patientBloc = PatientBloc(
      getPatientProfile: mockGetPatientProfileUseCase,
      updatePatientVitals: mockUpdatePatientVitalsUseCase,
    );
  });

  tearDown(() {
    patientBloc.close();
  });

  const tPatient = PatientEntity(
    id: 1,
    fullName: 'Test User',
    email: 'test@test.com',
    height: 180,
    weight: 80,
    bloodType: 'B+',
    allergies: [],
    chronicDiseases: [],
  );

  group('PatientBloc Tests', () {
    test('Initial state should be PatientInitial', () {
      expect(patientBloc.state, isA<PatientInitial>());
    });

    blocTest<PatientBloc, PatientState>(
      'LoadCurrentProfileEvent emits [PatientLoading, PatientLoaded] on success',
      build: () {
        when(
          () => mockGetPatientProfileUseCase(),
        ).thenAnswer((_) async => const Right(tPatient));
        return patientBloc;
      },
      act: (bloc) => bloc.add(const LoadCurrentProfileEvent()),
      expect: () => [
        isA<PatientLoading>(),
        isA<PatientLoaded>().having((s) => s.patient, 'patient', tPatient),
      ],
    );

    blocTest<PatientBloc, PatientState>(
      'LoadCurrentProfileEvent emits [PatientLoading, PatientError] on failure',
      build: () {
        when(() => mockGetPatientProfileUseCase()).thenAnswer(
          (_) async => const Left(ServerFailure(debugMessage: 'Error')),
        );
        return patientBloc;
      },
      act: (bloc) => bloc.add(const LoadCurrentProfileEvent()),
      expect: () => [
        isA<PatientLoading>(),
        isA<PatientError>().having(
          (s) => s.failure,
          'failure',
          isA<ServerFailure>(),
        ),
      ],
    );

    blocTest<PatientBloc, PatientState>(
      'UpdatePatientVitalsEvent triggers LoadCurrentProfileEvent on success',
      build: () {
        when(
          () => mockUpdatePatientVitalsUseCase(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetPatientProfileUseCase(),
        ).thenAnswer((_) async => const Right(tPatient));
        return patientBloc;
      },
      act: (bloc) =>
          bloc.add(const UpdatePatientVitalsEvent(height: 180, weight: 80)),
      expect: () => [
        isA<PatientLoading>(),
        isA<PatientLoaded>().having((s) => s.patient, 'patient', tPatient),
      ],
    );
  });
}
