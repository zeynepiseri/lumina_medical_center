import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/init/theme/app_dimens.dart';
import 'package:lumina_medical_center/core/init/theme/app_opacity.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_bloc.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_event.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_state.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/doctor_dashboard_bloc.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/doctor_dashboard_event.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/doctor_dashboard_state.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/pages/dashboard_home_page.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/widgets/appointment_list_section.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/widgets/dashboard_calendar.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardBloc extends MockBloc<DashboardEvent, DashboardState>
    implements DashboardBloc {}

class FakeDashboardEvent extends Fake implements DashboardEvent {}

class FakeDashboardState extends Fake implements DashboardState {}

class MockAppointmentActionBloc
    extends MockBloc<AppointmentActionEvent, AppointmentActionState>
    implements AppointmentActionBloc {}

class FakeAppointmentActionEvent extends Fake
    implements AppointmentActionEvent {}

class FakeAppointmentActionState extends Fake
    implements AppointmentActionState {}

void main() {
  late MockDashboardBloc mockBloc;
  late MockAppointmentActionBloc mockActionBloc;
  final GetIt sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(FakeDashboardEvent());
    registerFallbackValue(FakeDashboardState());
    registerFallbackValue(FakeAppointmentActionEvent());
    registerFallbackValue(FakeAppointmentActionState());
  });

  setUp(() async {
    await sl.reset();
    mockBloc = MockDashboardBloc();
    mockActionBloc = MockAppointmentActionBloc();

    when(() => mockActionBloc.state).thenReturn(ActionInitial());
    when(() => mockBloc.state).thenReturn(DashboardInitial());
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

          home: MultiBlocProvider(
            providers: [
              BlocProvider<DashboardBloc>.value(value: mockBloc),
              BlocProvider<AppointmentActionBloc>.value(value: mockActionBloc),
            ],
            child: const DoctorDashboardPage(),
          ),
        );
      },
    );
  }

  group('DoctorDashboardPage UI Tests', () {
    testWidgets('Initial state should trigger loading event', (tester) async {
      when(() => mockBloc.state).thenReturn(DashboardLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('The Dashboard components should appear when Loaded', (
      tester,
    ) async {
      final tDate = DateTime.now();
      when(() => mockBloc.state).thenReturn(DashboardLoaded(const [], tDate));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(DashboardAppBar), findsOneWidget);
      expect(find.byType(DashboardCalendar), findsOneWidget);
      expect(find.byType(AppointmentListSection), findsOneWidget);
    });
  });
}
