import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/init/theme/app_dimens.dart';
import 'package:lumina_medical_center/core/init/theme/app_opacity.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/register/register_state.dart';
import 'package:lumina_medical_center/features/auth/presentation/pages/register_page.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterCubit extends MockBloc<RegisterCubit, RegisterState>
    implements RegisterCubit {}

class FakeRegisterState extends Fake implements RegisterState {}

void main() {
  late MockRegisterCubit mockRegisterCubit;
  final GetIt sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(FakeRegisterState());
  });

  setUp(() async {
    mockRegisterCubit = MockRegisterCubit();
    await sl.reset();
    sl.registerFactory<RegisterCubit>(() => mockRegisterCubit);

    when(
      () => mockRegisterCubit.register(
        fullName: any(named: 'fullName'),
        email: any(named: 'email'),
        password: any(named: 'password'),
        nationalId: any(named: 'nationalId'),
        rawPhoneNumber: any(named: 'rawPhoneNumber'),
        gender: any(named: 'gender'),
        birthDate: any(named: 'birthDate'),
        chronicDiseasesText: any(named: 'chronicDiseasesText'),
        allergiesText: any(named: 'allergiesText'),
        medicationsText: any(named: 'medicationsText'),
      ),
    ).thenAnswer((_) async {});
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
          home: const RegisterPage(),
        );
      },
    );
  }

  group('RegisterPage UI Tests', () {
    testWidgets(
      'Required form fields and Register button should be on screen',
      (tester) async {
        when(() => mockRegisterCubit.state).thenReturn(RegisterInitial());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(TextFormField), findsAtLeastNWidgets(3));

        expect(find.byType(ElevatedButton), findsOneWidget);
      },
    );

    testWidgets(
      'CircularProgressIndicator should appear inside button in Loading state',
      (tester) async {
        when(() => mockRegisterCubit.state).thenReturn(RegisterLoading());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('SnackBar should be shown in case of error (RegisterFailure)', (
      tester,
    ) async {
      whenListen(
        mockRegisterCubit,
        Stream.fromIterable([
          RegisterLoading(),
          RegisterFailure(
            const ServerFailure(debugMessage: 'Email already exists'),
          ),
        ]),
        initialState: RegisterInitial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
