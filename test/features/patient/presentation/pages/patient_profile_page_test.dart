import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/init/theme/app_dimens.dart';
import 'package:lumina_medical_center/core/init/theme/app_opacity.dart';
import 'package:lumina_medical_center/features/patient/domain/entities/patient_entity.dart';
import 'package:lumina_medical_center/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:lumina_medical_center/features/patient/presentation/pages/patient_profile_page.dart';
import 'package:lumina_medical_center/features/profile/presentation/bloc/upload_bloc/upload_bloc.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockPatientBloc extends MockBloc<PatientEvent, PatientState>
    implements PatientBloc {}

class MockUploadBloc extends MockBloc<UploadEvent, UploadState>
    implements UploadBloc {}

void main() {
  late MockPatientBloc mockPatientBloc;
  late MockUploadBloc mockUploadBloc;
  final GetIt sl = GetIt.instance;

  const tPatient = PatientEntity(
    id: 1,
    fullName: 'Sarah Jonson',
    email: 'sarah@test.com',
    height: 165,
    weight: 55,
    bloodType: '0+',
  );

  setUp(() {
    mockPatientBloc = MockPatientBloc();
    mockUploadBloc = MockUploadBloc();

    sl.reset();
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
          home: const PatientProfilePage(),
        );
      },
    );
  }

  testWidgets('In case of loading, the Loading Indicator should appear', (
    tester,
  ) async {
    when(() => mockPatientBloc.state).thenReturn(PatientLoading());
    when(() => mockUploadBloc.state).thenReturn(UploadInitial());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    'Patient information should be displayed when the data is uploaded',
    (tester) async {
      when(
        () => mockPatientBloc.state,
      ).thenReturn(const PatientLoaded(tPatient));
      when(() => mockUploadBloc.state).thenReturn(UploadInitial());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Sarah Jonson'), findsOneWidget);
      expect(find.text('165.0 cm'), findsOneWidget);
      expect(find.text('0+'), findsOneWidget);
    },
  );

  testWidgets('When you press the Edit icon, the dialog should open', (
    tester,
  ) async {
    when(() => mockPatientBloc.state).thenReturn(const PatientLoaded(tPatient));
    when(() => mockUploadBloc.state).thenReturn(UploadInitial());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    final editIcon = find.byIcon(Icons.edit);
    expect(editIcon, findsOneWidget);

    await tester.tap(editIcon);
    await tester.pumpAndSettle();

    final dialogFinder = find.byType(Dialog);
    expect(dialogFinder, findsOneWidget);

    final iconInDialog = find.descendant(
      of: dialogFinder,
      matching: find.byIcon(Icons.height),
    );

    expect(iconInDialog, findsOneWidget);
  });
}
