import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/cancel_appointment_usecase.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/get_my_appointments_usecase.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/appointment_event.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/appointment_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMyAppointmentsUseCase extends Mock
    implements GetMyAppointmentsUseCase {}

class MockCancelAppointmentUseCase extends Mock
    implements CancelAppointmentUseCase {}

void main() {
  late AppointmentBloc appointmentBloc;
  late MockGetMyAppointmentsUseCase mockGetMyAppointmentsUseCase;
  late MockCancelAppointmentUseCase mockCancelAppointmentUseCase;

  final tNow = DateTime.now();

  final tUpcomingAppt = AppointmentEntity(
    id: 1,
    patientId: 101,
    patientName: 'Zeynep',
    doctorId: 202,
    doctorName: 'Dr. Ali',
    doctorTitle: 'Prof.',
    doctorSpecialty: 'Cardiology',
    doctorImageUrl: 'url',

    appointmentTime: tNow.add(const Duration(days: 1)).toIso8601String(),
    status: 'Confirmed',
    appointmentType: 'Online',
    healthIssue: 'Checkup',
    isAvailable: true,
  );

  final tPastAppt = AppointmentEntity(
    id: 2,
    patientId: 101,
    patientName: 'Zeynep',
    doctorId: 203,
    doctorName: 'Dr. Veli',
    doctorTitle: 'Dr.',
    doctorSpecialty: 'Dermatology',
    doctorImageUrl: 'url',

    appointmentTime: tNow.subtract(const Duration(days: 1)).toIso8601String(),
    status: 'Completed',
    appointmentType: 'In-Person',
    healthIssue: 'Acne',
    isAvailable: true,
  );

  final tCancelledAppt = AppointmentEntity(
    id: 3,
    patientId: 101,
    patientName: 'Zeynep',
    doctorId: 204,
    doctorName: 'Dr. Ayse',
    doctorTitle: 'Spec.',
    doctorSpecialty: 'Neurology',
    doctorImageUrl: 'url',

    appointmentTime: tNow.add(const Duration(days: 2)).toIso8601String(),
    status: 'Cancelled',
    appointmentType: 'Online',
    healthIssue: 'Migraine',
    isAvailable: true,
  );

  final tAllAppointments = [tUpcomingAppt, tPastAppt, tCancelledAppt];

  setUp(() {
    mockGetMyAppointmentsUseCase = MockGetMyAppointmentsUseCase();
    mockCancelAppointmentUseCase = MockCancelAppointmentUseCase();

    appointmentBloc = AppointmentBloc(
      getMyAppointmentsUseCase: mockGetMyAppointmentsUseCase,
      cancelAppointmentUseCase: mockCancelAppointmentUseCase,
    );
  });

  tearDown(() {
    appointmentBloc.close();
  });

  group('AppointmentBloc Tests', () {
    test('Initial state should be AppointmentState.initial', () {
      expect(appointmentBloc.state.status, AppointmentStatus.initial);
    });

    group('LoadAppointmentsEvent', () {
      blocTest<AppointmentBloc, AppointmentState>(
        'Should correctly separate and sort into Upcoming and Past when data arrives',
        build: () {
          when(
            () => mockGetMyAppointmentsUseCase(),
          ).thenAnswer((_) async => Right(tAllAppointments));
          return appointmentBloc;
        },
        act: (bloc) => bloc.add(LoadAppointmentsEvent()),
        expect: () => [
          isA<AppointmentState>().having(
            (s) => s.status,
            'status',
            AppointmentStatus.loading,
          ),

          isA<AppointmentState>()
              .having((s) => s.status, 'status', AppointmentStatus.success)
              .having(
                (s) => s.upcomingAppointments,
                'upcoming',
                containsAll([tUpcomingAppt]),
              )
              .having(
                (s) => s.pastAppointments,
                'past',
                containsAllInOrder([tCancelledAppt, tPastAppt]),
              ),
        ],
      );

      blocTest<AppointmentBloc, AppointmentState>(
        'Should emit Failure state if Usecase returns error',
        build: () {
          when(() => mockGetMyAppointmentsUseCase()).thenAnswer(
            (_) async => const Left(ServerFailure(debugMessage: 'API Error')),
          );
          return appointmentBloc;
        },
        act: (bloc) => bloc.add(LoadAppointmentsEvent()),
        expect: () => [
          isA<AppointmentState>().having(
            (s) => s.status,
            'status',
            AppointmentStatus.loading,
          ),
          isA<AppointmentState>()
              .having((s) => s.status, 'status', AppointmentStatus.failure)
              .having((s) => s.errorMessage, 'error', 'API Error'),
        ],
      );
    });

    group('CancelAppointmentEvent', () {
      const tAppointmentId = 1;

      blocTest<AppointmentBloc, AppointmentState>(
        'LoadAppointmentsEvent should be triggered and list refreshed if cancellation is successful',
        build: () {
          when(
            () => mockCancelAppointmentUseCase(tAppointmentId),
          ).thenAnswer((_) async => const Right(null));

          when(
            () => mockGetMyAppointmentsUseCase(),
          ).thenAnswer((_) async => const Right([]));

          return appointmentBloc;
        },
        act: (bloc) => bloc.add(const CancelAppointmentEvent(tAppointmentId)),

        expect: () => [
          isA<AppointmentState>().having(
            (s) => s.status,
            'status',
            AppointmentStatus.loading,
          ),
          isA<AppointmentState>()
              .having((s) => s.status, 'status', AppointmentStatus.success)
              .having((s) => s.upcomingAppointments, 'empty', isEmpty),
        ],
        verify: (_) {
          verify(() => mockCancelAppointmentUseCase(tAppointmentId)).called(1);

          verify(() => mockGetMyAppointmentsUseCase()).called(1);
        },
      );

      blocTest<AppointmentBloc, AppointmentState>(
        'Should emit Failure state if cancellation fails',
        build: () {
          when(() => mockCancelAppointmentUseCase(tAppointmentId)).thenAnswer(
            (_) async =>
                const Left(ServerFailure(debugMessage: 'Cancel Failed')),
          );
          return appointmentBloc;
        },
        act: (bloc) => bloc.add(const CancelAppointmentEvent(tAppointmentId)),
        expect: () => [
          isA<AppointmentState>()
              .having((s) => s.status, 'status', AppointmentStatus.failure)
              .having((s) => s.errorMessage, 'error', 'Cancel Failed'),
        ],
      );
    });
  });
}
