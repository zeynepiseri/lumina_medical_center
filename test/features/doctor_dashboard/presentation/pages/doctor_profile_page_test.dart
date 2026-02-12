import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/init/theme/app_dimens.dart';
import 'package:lumina_medical_center/core/init/theme/app_opacity.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/entities/my_profile_entity.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/profile/doctor_profile_edit_bloc.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/profile/doctor_profile_edit_event.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/profile/doctor_profile_edit_state.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/pages/doctor_profile_page.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements DoctorProfileBloc {}

class FakeProfileEvent extends Fake implements ProfileEvent {}

class FakeProfileState extends Fake implements ProfileState {}

void main() {
  late MockDoctorProfileBloc mockBloc;
  final GetIt sl = GetIt.instance;

  final tProfile = MyProfileEntity(
    id: 1,
    fullName: 'Dr. Zeynep',
    title: 'Prof.',
    branchName: 'Neurology',
    biography: 'Expert in brain.',
    experience: 10,
    diplomaNo: '12345',
    email: 'zeynep@test.com',
    phoneNumber: '5551234567',
    nationalId: '11122233344',
    imageUrl: 'url',
    schedules: const [],
    subSpecialties: const ['Migraine'],
    educations: const ['Hacettepe'],
    patientCount: 500,
  );

  setUpAll(() {
    registerFallbackValue(FakeProfileEvent());
    registerFallbackValue(FakeProfileState());
  });

  setUp(() async {
    mockBloc = MockDoctorProfileBloc();
    await sl.reset();
    sl.registerFactory<DoctorProfileBloc>(() => mockBloc);
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
          home: BlocProvider<DoctorProfileBloc>.value(
            value: mockBloc,
            child: const DoctorProfilePage(),
          ),
        );
      },
    );
  }

  group('DoctorProfilePage UI Tests', () {
    testWidgets(
      'The CircularProgressIndicator should appear in the loading state.',
      (tester) async {
        when(() => mockBloc.state).thenReturn(ProfileLoading());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'Information should appear on the screen when the profile is uploaded',
      (tester) async {
        when(() => mockBloc.state).thenReturn(ProfileLoading());
        whenListen(mockBloc, Stream.fromIterable([ProfileLoaded(tProfile)]));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Dr. Sarah'), findsOneWidget);

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextFormField &&
                widget.controller?.text == 'Expert in brain.',
          ),
          findsOneWidget,
        );

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextFormField && widget.controller?.text == '10',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'The UpdateProfileEvent should be triggered when the save button is clicked.',
      (tester) async {
        when(() => mockBloc.state).thenReturn(ProfileLoading());
        whenListen(mockBloc, Stream.fromIterable([ProfileLoaded(tProfile)]));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final bioField = find.byWidgetPredicate(
          (widget) =>
              widget is TextFormField &&
              widget.controller?.text == 'Expert in brain.',
        );

        await tester.enterText(bioField, 'Updated Bio');
        await tester.pump();

        final saveButton = find.byType(ElevatedButton).last;

        await tester.scrollUntilVisible(
          saveButton,
          500.0,
          scrollable: find.byType(Scrollable).first,
        );

        await tester.tap(saveButton);
        await tester.pump();

        verify(
          () => mockBloc.add(
            any(
              that: isA<UpdateProfileEvent>().having(
                (e) => e.biography,
                'bio',
                'Updated Bio',
              ),
            ),
          ),
        ).called(1);
      },
    );
  });
}
