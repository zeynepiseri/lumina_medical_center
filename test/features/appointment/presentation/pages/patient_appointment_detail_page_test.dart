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
import 'package:lumina_medical_center/features/appointment/presentation/pages/patient_appointment_detail_page.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/appointment_action_buttons.dart';
import 'package:lumina_medical_center/features/find_doctor/data/datasources/doctor_service.dart';
import 'package:lumina_medical_center/features/find_doctor/data/models/doctor_model.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class FakeAppointmentActionEvent extends Fake
    implements AppointmentActionEvent {}

class FakeAppointmentActionState extends Fake
    implements AppointmentActionState {}

class MockAppointmentActionBloc
    extends MockBloc<AppointmentActionEvent, AppointmentActionState>
    implements AppointmentActionBloc {}

class MockDoctorService extends Mock implements DoctorService {}

void main() {
  late MockAppointmentActionBloc mockBloc;
  late MockDoctorService mockDoctorService;
  final GetIt sl = GetIt.instance;

  final tAppointment = AppointmentEntity(
    id: 1,
    patientId: 101,
    patientName: 'Jane Doe',
    doctorId: 202,
    doctorName: 'Dr. Ali Veli',
    doctorTitle: 'Prof.',
    doctorSpecialty: 'Cardiology',
    doctorImageUrl: 'url',
    appointmentTime: DateTime.now()
        .add(const Duration(days: 1))
        .toIso8601String(),
    status: 'Upcoming',
    appointmentType: 'Online',
    healthIssue: 'Heart Pain',
    isAvailable: true,
  );

  final tDoctorModel = DoctorModel(
    id: 202,
    fullName: 'Dr. Ali Veli',
    specialty: 'Cardiology',
    title: 'Prof.',
    imageUrl: 'url',
    biography: 'Bio',
    branchId: 1,
    branchName: 'Central',
    experience: 10,
    patientCount: 100,
    rating: 4.5,
    reviewCount: 10,
    consultationFee: 500,
    certificates: [],
    languages: ['TR'],
    schedules: [],
    subSpecialties: [],
    professionalExperiences: [],
    educations: [],
    acceptedInsurances: [],
  );

  setUpAll(() {
    registerFallbackValue(FakeAppointmentActionEvent());
    registerFallbackValue(FakeAppointmentActionState());
  });

  setUp(() async {
    mockBloc = MockAppointmentActionBloc();
    mockDoctorService = MockDoctorService();

    await sl.reset();
    sl.registerFactory<AppointmentActionBloc>(() => mockBloc);
    sl.registerFactory<DoctorService>(() => mockDoctorService);

    when(
      () => mockDoctorService.getDoctorById(any()),
    ).thenAnswer((_) async => tDoctorModel);
  });

  Widget createWidgetUnderTest() {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.white,
            primaryColor: AppColors.midnightBlue,
            extensions: <ThemeExtension<dynamic>>[
              AppSpacing.regular,
              AppRadius.regular,
              AppOpacity.regular,
              AppLayout.regular,
            ],
          ),
          home: Scaffold(
            body: PatientAppointmentDetailDialog(appointment: tAppointment),
          ),
        );
      },
    );
  }

  group('PatientAppointmentDetailDialog UI Tests', () {
    testWidgets('Doctor name should be visible when page opens', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(ActionInitial());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.textContaining('Dr. Ali Veli'), findsOneWidget);
    });

    testWidgets(
      'Confirmation dialog should open when Cancel button is pressed',
      (tester) async {
        when(() => mockBloc.state).thenReturn(ActionInitial());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        Finder cancelBtnFinder = find.text('Cancel Appointment');
        if (cancelBtnFinder.evaluate().isEmpty)
          cancelBtnFinder = find.text('Cancel');
        if (cancelBtnFinder.evaluate().isEmpty)
          cancelBtnFinder = find.byType(OutlinedButton).first;

        await tester.scrollUntilVisible(cancelBtnFinder, 500.0);
        await tester.tap(cancelBtnFinder);
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(AlertDialog), findsOneWidget);
      },
    );

    testWidgets(
      'CancelAppointmentEvent should be sent when "Yes, Cancel" is clicked in dialog',
      (tester) async {
        when(() => mockBloc.state).thenReturn(ActionInitial());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        Finder cancelBtnFinder = find.text('Cancel Appointment');
        if (cancelBtnFinder.evaluate().isEmpty)
          cancelBtnFinder = find.text('Cancel');
        if (cancelBtnFinder.evaluate().isEmpty)
          cancelBtnFinder = find.byType(OutlinedButton).first;

        await tester.scrollUntilVisible(cancelBtnFinder, 500.0);
        await tester.tap(cancelBtnFinder);
        await tester.pump(const Duration(milliseconds: 500));

        Finder confirmBtn = find.text('Yes, cancel');
        if (confirmBtn.evaluate().isEmpty) confirmBtn = find.text('Yes');
        if (confirmBtn.evaluate().isEmpty) {
          confirmBtn = find.descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(ElevatedButton),
          );
        }

        await tester.tap(confirmBtn);
        await tester.pump(const Duration(milliseconds: 500));

        verify(
          () => mockBloc.add(any(that: isA<CancelAppointmentEvent>())),
        ).called(1);
      },
    );

    testWidgets(
      'Buttons should disappear and loading should appear in ActionLoading state',
      (tester) async {
        whenListen(
          mockBloc,
          Stream.fromIterable([ActionLoading()]),
          initialState: ActionLoading(),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        await tester.pump();

        expect(find.byType(AppointmentActionButtons), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      },
    );
  });
}
