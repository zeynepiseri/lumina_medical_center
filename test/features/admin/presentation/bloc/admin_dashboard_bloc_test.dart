import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:lumina_medical_center/features/admin/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_dashboard_bloc.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_dashboard_event.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_dashboard_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDashboardStatsUseCase extends Mock
    implements GetDashboardStatsUseCase {}

void main() {
  late AdminDashboardBloc bloc;
  late MockGetDashboardStatsUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetDashboardStatsUseCase();
    bloc = AdminDashboardBloc(mockUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  const tStats = AdminStatsEntity(
    totalDoctors: 10,
    totalPatients: 100,
    totalAppointments: 50,
    topDoctors: [],

    monthlyEarnings: 15000.0,
    monthlyAppointmentsData: [],
    monthLabels: [],
    topDoctorName: 'Dr. Best',
    topDoctorBranch: 'Cardio',
  );

  group('AdminDashboardBloc Tests', () {
    test('Initial state is AdminDashboardInitial', () {
      expect(bloc.state, isA<AdminDashboardInitial>());
    });

    blocTest<AdminDashboardBloc, AdminDashboardState>(
      'LoadAdminDashboard emits [Loading, Loaded] on success',
      build: () {
        when(() => mockUseCase()).thenAnswer((_) async => const Right(tStats));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAdminDashboard()),
      expect: () => [
        isA<AdminDashboardLoading>(),
        isA<AdminDashboardLoaded>().having((s) => s.stats, 'stats', tStats),
      ],
    );

    blocTest<AdminDashboardBloc, AdminDashboardState>(
      'LoadAdminDashboard emits [Loading, Error] on failure',
      build: () {
        when(() => mockUseCase()).thenAnswer(
          (_) async => const Left(ServerFailure(debugMessage: 'Error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAdminDashboard()),
      expect: () => [isA<AdminDashboardLoading>(), isA<AdminDashboardError>()],
    );
  });
}
