import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/features/appointment/data/datasources/appointment_service.dart';

import 'package:lumina_medical_center/features/appointment/data/models/appointment_model.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/doctor_dashboard_bloc.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/doctor_dashboard_event.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/doctor_dashboard_state.dart';
import 'package:mocktail/mocktail.dart';

class MockAppointmentService extends Mock implements AppointmentService {}

class FakeAppointment extends Fake implements AppointmentModel {
  final DateTime _dt;
  FakeAppointment(this._dt);

  @override
  String get appointmentTime => _dt.toIso8601String();
}

void main() {
  late DashboardBloc dashboardBloc;
  late MockAppointmentService mockAppointmentService;

  final tDate = DateTime(2026, 10, 10);
  final tApp9am = FakeAppointment(DateTime(2026, 10, 10, 09, 00));
  final tApp10am = FakeAppointment(DateTime(2026, 10, 10, 10, 00));

  setUp(() {
    mockAppointmentService = MockAppointmentService();
    dashboardBloc = DashboardBloc(mockAppointmentService);
  });

  tearDown(() {
    dashboardBloc.close();
  });

  group('DashboardBloc Tests', () {
    test('Initial state should be DashboardInitial', () {
      expect(dashboardBloc.state, isA<DashboardInitial>());
    });

    group('LoadAppointmentsByDate', () {
      blocTest<DashboardBloc, DashboardState>(
        'Appointments must be loaded successfully and sorted by time.',
        build: () {
          when(
            () => mockAppointmentService.getAppointmentsByDate(tDate),
          ).thenAnswer((_) async => [tApp10am, tApp9am]);
          return dashboardBloc;
        },
        act: (bloc) => bloc.add(LoadAppointmentsByDate(tDate)),
        expect: () => [
          isA<DashboardLoading>(),
          isA<DashboardLoaded>()
              .having((s) => s.selectedDate, 'date', tDate)
              .having((s) => s.appointments.length, 'count', 2)
              .having((s) => s.appointments.first, 'sorted first', tApp9am),
        ],
        verify: (_) {
          verify(
            () => mockAppointmentService.getAppointmentsByDate(tDate),
          ).called(1);
        },
      );

      blocTest<DashboardBloc, DashboardState>(
        'If the service gives an error, the DashboardError should be propagated',
        build: () {
          when(
            () => mockAppointmentService.getAppointmentsByDate(any()),
          ).thenThrow(Exception('API Error'));
          return dashboardBloc;
        },
        act: (bloc) => bloc.add(LoadAppointmentsByDate(tDate)),
        expect: () => [
          isA<DashboardLoading>(),
          isA<DashboardError>().having(
            (s) => s.message,
            'message',
            'dashboardLoadError',
          ),
        ],
      );

      blocTest<DashboardBloc, DashboardState>(
        'If the same date is already loaded and forceRefresh is not present, the request should not be thrown again',
        build: () {
          return dashboardBloc;
        },
        seed: () => DashboardLoaded([tApp9am], tDate),
        act: (bloc) => bloc.add(LoadAppointmentsByDate(tDate)),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => mockAppointmentService.getAppointmentsByDate(any()),
          );
        },
      );

      blocTest<DashboardBloc, DashboardState>(
        'Even if it is the same date, forceRefresh: if true, it should install again',
        build: () {
          when(
            () => mockAppointmentService.getAppointmentsByDate(tDate),
          ).thenAnswer((_) async => [tApp9am]);
          return dashboardBloc;
        },
        seed: () => DashboardLoaded([tApp9am], tDate),
        act: (bloc) =>
            bloc.add(LoadAppointmentsByDate(tDate, forceRefresh: true)),
        expect: () => [isA<DashboardLoading>(), isA<DashboardLoaded>()],
        verify: (_) {
          verify(
            () => mockAppointmentService.getAppointmentsByDate(tDate),
          ).called(1);
        },
      );
    });
  });
}
