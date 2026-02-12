import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/cancel_appointment_usecase.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/reschedule_appointment_usecase.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_bloc.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_event.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_state.dart';
import 'package:mocktail/mocktail.dart';

class MockCancelAppointmentUseCase extends Mock
    implements CancelAppointmentUseCase {}

class MockRescheduleAppointmentUseCase extends Mock
    implements RescheduleAppointmentUseCase {}

void main() {
  late AppointmentActionBloc bloc;
  late MockCancelAppointmentUseCase mockCancelUseCase;
  late MockRescheduleAppointmentUseCase mockRescheduleUseCase;

  setUp(() {
    mockCancelUseCase = MockCancelAppointmentUseCase();
    mockRescheduleUseCase = MockRescheduleAppointmentUseCase();

    bloc = AppointmentActionBloc(
      cancelAppointmentUseCase: mockCancelUseCase,
      rescheduleAppointmentUseCase: mockRescheduleUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('AppointmentActionBloc Tests', () {
    test('Initial state should be ActionInitial', () {
      expect(bloc.state, equals(ActionInitial()));
    });

    group('CancelAppointmentEvent', () {
      const tAppointmentIdStr = '123';
      const tAppointmentIdInt = 123;

      blocTest<AppointmentActionBloc, AppointmentActionState>(
        'Should emit [Loading, Success] if ID is valid and operation is successful',
        build: () {
          when(
            () => mockCancelUseCase(tAppointmentIdInt),
          ).thenAnswer((_) async => const Right(null));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const CancelAppointmentEvent(tAppointmentIdStr)),
        expect: () => [
          ActionLoading(),
          const ActionSuccess("appointmentCanceledSuccessfully"),
        ],
        verify: (_) {
          verify(() => mockCancelUseCase(tAppointmentIdInt)).called(1);
        },
      );

      blocTest<AppointmentActionBloc, AppointmentActionState>(
        'Should emit [Loading, Error] if ID is invalid (not int)',
        build: () => bloc,
        act: (bloc) => bloc.add(const CancelAppointmentEvent('abc')),
        expect: () => [ActionLoading(), const ActionError("invalidId")],
      );

      blocTest<AppointmentActionBloc, AppointmentActionState>(
        'Should emit [Loading, Error] in case of service error',
        build: () {
          when(() => mockCancelUseCase(any())).thenAnswer(
            (_) async => const Left(ServerFailure(debugMessage: 'Server Fail')),
          );
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const CancelAppointmentEvent(tAppointmentIdStr)),
        expect: () => [ActionLoading(), const ActionError('Server Fail')],
      );
    });

    group('RescheduleAppointmentEvent', () {
      const tAppointmentIdStr = '123';
      const tAppointmentIdInt = 123;
      final tNewDate = DateTime(2026, 10, 10);

      blocTest<AppointmentActionBloc, AppointmentActionState>(
        'Should emit [Loading, Success] if rescheduling is successful (true)',
        build: () {
          when(
            () => mockRescheduleUseCase(tAppointmentIdInt, tNewDate),
          ).thenAnswer((_) async => const Right(true));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(RescheduleAppointmentEvent(tAppointmentIdStr, tNewDate)),
        expect: () => [
          ActionLoading(),
          const ActionSuccess("appointmentRescheduledSuccess"),
        ],
      );

      blocTest<AppointmentActionBloc, AppointmentActionState>(
        'Should emit [Loading, Error] if rescheduling fails (false)',
        build: () {
          when(
            () => mockRescheduleUseCase(any(), any()),
          ).thenAnswer((_) async => const Right(false));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(RescheduleAppointmentEvent(tAppointmentIdStr, tNewDate)),
        expect: () => [
          ActionLoading(),
          const ActionError("appointmentRescheduleFailed"),
        ],
      );

      blocTest<AppointmentActionBloc, AppointmentActionState>(
        'Should emit [Loading, Error] in case of service error',
        build: () {
          when(() => mockRescheduleUseCase(any(), any())).thenAnswer(
            (_) async =>
                const Left(ServerFailure(debugMessage: 'Limit Reached')),
          );
          return bloc;
        },
        act: (bloc) =>
            bloc.add(RescheduleAppointmentEvent(tAppointmentIdStr, tNewDate)),
        expect: () => [ActionLoading(), const ActionError('Limit Reached')],
      );
    });
  });
}
