import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/init/theme/app_dimens.dart';
import 'package:lumina_medical_center/core/init/theme/app_opacity.dart';
import 'package:lumina_medical_center/features/patient/domain/entities/patient_entity.dart';
import 'package:lumina_medical_center/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:lumina_medical_center/features/profile/presentation/bloc/upload_bloc/upload_bloc.dart';
import 'package:lumina_medical_center/features/profile/presentation/pages/profile_page.dart';
import 'package:lumina_medical_center/features/profile/presentation/widgets/edit_vitals_dialog.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockPatientBloc extends MockBloc<PatientEvent, PatientState>
    implements PatientBloc {}

class FakePatientEvent extends Fake implements PatientEvent {}

class FakePatientState extends Fake implements PatientState {}

class MockUploadBloc extends MockBloc<UploadEvent, UploadState>
    implements UploadBloc {}

class FakeUploadEvent extends Fake implements UploadEvent {}

class FakeUploadState extends Fake implements UploadState {}

void main() {
  late MockPatientBloc mockPatientBloc;
  late MockUploadBloc mockUploadBloc;
  final GetIt sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(FakePatientEvent());
    registerFallbackValue(FakePatientState());
    registerFallbackValue(FakeUploadEvent());
    registerFallbackValue(FakeUploadState());
  });

  setUp(() async {
    await sl.reset();
    mockPatientBloc = MockPatientBloc();
    mockUploadBloc = MockUploadBloc();

    sl.registerFactory<PatientBloc>(() => mockPatientBloc);
    sl.registerFactory<UploadBloc>(() => mockUploadBloc);
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
            scaffoldBackgroundColor: AppColors.white,
            extensions: <ThemeExtension<dynamic>>[
              AppSpacing.regular,
              AppRadius.regular,
              AppOpacity.regular,
              AppLayout.regular,
            ],
          ),
          home: const PatientProfilePage(),
        );
      },
    );
  }

  final tPatient = PatientEntity(
    id: 1,
    fullName: 'Sarah User',
    email: 'test@test.com',
    phoneNumber: '555',
    gender: 'Female',
    birthDate: DateTime(1995, 1, 1),
    nationalId: '123456',

    height: 165.0,
    weight: 55.0,
    bloodType: 'A+',
    allergies: const ['Pollen'],
    chronicDiseases: const [],
    imageUrl: '',
  );

  group('PatientProfilePage UI Tests', () {
    testWidgets(
      'CircularProgressIndicator should appear in the installation state',
      (tester) async {
        when(() => mockPatientBloc.state).thenReturn(PatientLoading());
        when(() => mockUploadBloc.state).thenReturn(UploadInitial());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'When patient data is loaded, the Profile, Vitals, and Menus should appear.',
      (tester) async {
        when(() => mockPatientBloc.state).thenReturn(PatientLoaded(tPatient));
        when(() => mockUploadBloc.state).thenReturn(UploadInitial());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Sarah User'), findsOneWidget);
        expect(find.textContaining('165'), findsOneWidget);
        expect(find.textContaining('55.0'), findsOneWidget);
        expect(find.text('A+'), findsOneWidget);
        expect(find.text('Pollen'), findsOneWidget);
      },
    );

    testWidgets(
      'When the edit icon is clicked, the EditVitalsDialog should open.',
      (tester) async {
        when(() => mockPatientBloc.state).thenReturn(PatientLoaded(tPatient));
        when(() => mockUploadBloc.state).thenReturn(UploadInitial());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final editIcon = find.byIcon(Icons.edit_rounded);
        expect(editIcon, findsOneWidget);

        await tester.tap(editIcon);
        await tester.pumpAndSettle();

        expect(find.byType(EditVitalsDialog), findsOneWidget);
        expect(find.text('165.0'), findsOneWidget);
      },
    );
  });
}
