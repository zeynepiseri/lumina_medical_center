import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/init/theme/app_dimens.dart';
import 'package:lumina_medical_center/core/init/theme/app_opacity.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_dashboard_bloc.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_dashboard_event.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_dashboard_state.dart';
import 'package:lumina_medical_center/features/admin/presentation/pages/dashboard_screen.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/admin_dashboard/admin_dashboard_metrics_grid.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/admin_dashboard/admin_storage_details_card.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/admin_dashboard/top_doctors_table.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/admin_header.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockAdminDashboardBloc
    extends MockBloc<AdminDashboardEvent, AdminDashboardState>
    implements AdminDashboardBloc {}

class FakeAdminDashboardEvent extends Fake implements AdminDashboardEvent {}

class FakeAdminDashboardState extends Fake implements AdminDashboardState {}

void main() {
  late MockAdminDashboardBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeAdminDashboardEvent());
    registerFallbackValue(FakeAdminDashboardState());
  });

  setUp(() {
    mockBloc = MockAdminDashboardBloc();

    when(() => mockBloc.state).thenReturn(AdminDashboardInitial());
  });

  Widget createWidgetUnderTest() {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.background,

            extensions: <ThemeExtension<dynamic>>[
              AppSpacing.regular,
              AppRadius.regular,
              AppOpacity.regular,
              AppLayout.regular,
            ],
          ),
          home: BlocProvider<AdminDashboardBloc>.value(
            value: mockBloc,
            child: DashboardScreen(onMenuPressed: () {}),
          ),
        );
      },
    );
  }

  const tStats = AdminStatsEntity(
    totalDoctors: 10,
    totalPatients: 100,
    totalAppointments: 50,
    topDoctors: [],
    monthlyEarnings: 15000.0,
    monthlyAppointmentsData: [10, 20],
    monthLabels: ["Jan", "Feb"],
    topDoctorName: 'Dr. Best',
    topDoctorBranch: 'Cardio',
  );

  group('DashboardScreen UI Tests', () {
    testWidgets('Loading state shows CircularProgressIndicator', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(AdminDashboardLoading());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Loaded state shows Dashboard widgets', (tester) async {
      when(() => mockBloc.state).thenReturn(const AdminDashboardLoaded(tStats));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(AdminHeader), findsOneWidget);
      expect(find.byType(DashboardMetricsGrid), findsOneWidget);
      expect(find.byType(TopDoctorsTable), findsOneWidget);
      expect(find.byType(StorageDetailsCard), findsOneWidget);
    });
  });
}
