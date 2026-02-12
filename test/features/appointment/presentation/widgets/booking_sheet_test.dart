import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/init/theme/app_dimens.dart';
import 'package:lumina_medical_center/core/init/theme/app_opacity.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_bloc.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_event.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_state.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/booking/booking_bloc.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/booking/date_strip.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/booking/time_slot_grid.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/booking_sheet.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingBloc extends MockBloc<BookingEvent, BookingState>
    implements BookingBloc {}

class FakeBookingEvent extends Fake implements BookingEvent {}

class FakeBookingState extends Fake implements BookingState {}

class MockAppointmentActionBloc
    extends MockBloc<AppointmentActionEvent, AppointmentActionState>
    implements AppointmentActionBloc {}

class FakeAppointmentActionEvent extends Fake
    implements AppointmentActionEvent {}

class FakeAppointmentActionState extends Fake
    implements AppointmentActionState {}

void main() {
  late MockBookingBloc mockBookingBloc;
  late MockAppointmentActionBloc mockAppointmentActionBloc;
  final GetIt sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(FakeBookingEvent());
    registerFallbackValue(FakeBookingState());
    registerFallbackValue(FakeAppointmentActionEvent());
    registerFallbackValue(FakeAppointmentActionState());
  });

  setUp(() async {
    await sl.reset();
    mockBookingBloc = MockBookingBloc();
    mockAppointmentActionBloc = MockAppointmentActionBloc();

    sl.registerFactory<BookingBloc>(() => mockBookingBloc);
    sl.registerFactory<AppointmentActionBloc>(() => mockAppointmentActionBloc);

    when(() => mockAppointmentActionBloc.state).thenReturn(ActionInitial());
  });

  Widget createWidgetUnderTest(DoctorEntity doctor) {
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
            scaffoldBackgroundColor: AppColors.white,
            extensions: <ThemeExtension<dynamic>>[
              AppSpacing.regular,
              AppRadius.regular,
              AppOpacity.regular,
              AppLayout.regular,
            ],
          ),
          home: Scaffold(body: BookingSheet(doctor: doctor)),
        );
      },
    );
  }

  const tDoctor = DoctorEntity(
    id: 1,
    fullName: 'Dr. House',
    specialty: 'Diagnostic',
    imageUrl: '',
    title: 'MD',
    branchName: 'Internal',
    rating: 4.8,
    patientCount: 1000,
  );

  group('BookingSheet UI Tests', () {
    testWidgets('DateStrip and title should be visible on initial open', (
      tester,
    ) async {
      when(
        () => mockBookingBloc.state,
      ).thenReturn(const BookingState(status: BookingStatus.initial));

      await tester.pumpWidget(createWidgetUnderTest(tDoctor));
      await tester.pumpAndSettle();

      expect(find.byType(DateStrip), findsOneWidget);
    });

    testWidgets('TimeSlotGrid should be visible when slots are loaded', (
      tester,
    ) async {
      final tDate = DateTime.now().add(const Duration(days: 1));
      when(() => mockBookingBloc.state).thenReturn(
        BookingState(
          status: BookingStatus.loaded,
          next14Days: [tDate],
          bookedSlots: const [],
          selectedDateIndex: 0,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest(tDoctor));
      await tester.pumpAndSettle();

      expect(find.byType(TimeSlotGrid), findsOneWidget);
    });

    testWidgets(
      '"Confirm Booking" button should be active when time is selected',
      (tester) async {
        final tDate = DateTime.now().add(const Duration(days: 1));
        when(() => mockBookingBloc.state).thenReturn(
          BookingState(
            status: BookingStatus.loaded,
            next14Days: [tDate],
            selectedDateIndex: 0,
            selectedTime: '10:00',
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest(tDoctor));
        await tester.pumpAndSettle();

        final confirmBtn = find.widgetWithText(
          ElevatedButton,
          'Confirm Booking',
        );
        expect(confirmBtn, findsOneWidget);

        final buttonWidget = tester.widget<ElevatedButton>(confirmBtn);
        expect(buttonWidget.onPressed, isNotNull);
      },
    );
  });
}
