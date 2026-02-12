import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/init/theme/app_dimens.dart';
import 'package:lumina_medical_center/core/init/theme/app_opacity.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_bloc.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_event.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_state.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/appointment_event.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/appointment_state.dart';
import 'package:lumina_medical_center/features/appointment/presentation/pages/my_appointments_page.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/appointment_card.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockAppointmentBloc extends MockBloc<AppointmentEvent, AppointmentState>
    implements AppointmentBloc {}

class FakeAppointmentEvent extends Fake implements AppointmentEvent {}

class FakeAppointmentState extends Fake implements AppointmentState {}

class MockAppointmentActionBloc
    extends MockBloc<AppointmentActionEvent, AppointmentActionState>
    implements AppointmentActionBloc {}

class FakeAppointmentActionEvent extends Fake
    implements AppointmentActionEvent {}

class FakeAppointmentActionState extends Fake
    implements AppointmentActionState {}

void main() {
  late MockAppointmentBloc mockAppointmentBloc;
  late MockAppointmentActionBloc mockAppointmentActionBloc;
  final GetIt sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(FakeAppointmentEvent());
    registerFallbackValue(FakeAppointmentState());
    registerFallbackValue(FakeAppointmentActionEvent());
    registerFallbackValue(FakeAppointmentActionState());
  });

  setUp(() async {
    await sl.reset();
    mockAppointmentBloc = MockAppointmentBloc();
    mockAppointmentActionBloc = MockAppointmentActionBloc();

    sl.registerFactory<AppointmentBloc>(() => mockAppointmentBloc);
    sl.registerFactory<AppointmentActionBloc>(() => mockAppointmentActionBloc);

    when(() => mockAppointmentActionBloc.state).thenReturn(ActionInitial());
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
          home: const MyAppointmentsPage(),
        );
      },
    );
  }

  final tAppointment = AppointmentEntity(
    id: 1,
    patientId: 101,
    doctorId: 202,
    doctorName: 'Dr. House',
    doctorTitle: 'MD',
    doctorSpecialty: 'Diagnostic',
    doctorImageUrl: '',
    appointmentTime: DateTime.now()
        .add(const Duration(days: 1))
        .toIso8601String(),
    status: 'SCHEDULED',
    appointmentType: 'Online',
    patientName: 'John Doe',
    healthIssue: 'Pain',
    isAvailable: false,
  );

  group('MyAppointmentsPage UI Tests', () {
    testWidgets('Loading state should show CircularProgressIndicator', (
      tester,
    ) async {
      when(
        () => mockAppointmentBloc.state,
      ).thenReturn(const AppointmentState(status: AppointmentStatus.loading));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Loaded state with appointments should show AppointmentCard', (
      tester,
    ) async {
      when(() => mockAppointmentBloc.state).thenReturn(
        AppointmentState(
          status: AppointmentStatus.success,
          upcomingAppointments: [tAppointment],
          pastAppointments: const [],
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Dr. House'), findsOneWidget);
      expect(find.byType(AppointmentCard), findsOneWidget);
    });

    testWidgets('Empty state should show "No appointments" message', (
      tester,
    ) async {
      when(() => mockAppointmentBloc.state).thenReturn(
        const AppointmentState(
          status: AppointmentStatus.success,
          upcomingAppointments: [],
          pastAppointments: [],
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('No appointments found'), findsOneWidget);
    });

    testWidgets('Error state should show error message', (tester) async {
      const errorMessage = 'Failed to load';
      when(() => mockAppointmentBloc.state).thenReturn(
        const AppointmentState(
          status: AppointmentStatus.failure,
          errorMessage: errorMessage,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
