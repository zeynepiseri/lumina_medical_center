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
import 'package:lumina_medical_center/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/login/login_state.dart';
import 'package:lumina_medical_center/features/auth/presentation/pages/login_page.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginCubit extends MockBloc<LoginCubit, LoginState>
    implements LoginCubit {}

class FakeLoginState extends Fake implements LoginState {}

void main() {
  late MockLoginCubit mockLoginCubit;
  final GetIt sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(FakeLoginState());
  });

  setUp(() async {
    mockLoginCubit = MockLoginCubit();
    await sl.reset();
    sl.registerFactory<LoginCubit>(() => mockLoginCubit);

    when(() => mockLoginCubit.login(any(), any())).thenAnswer((_) async {});
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
          home: const LoginPage(),
        );
      },
    );
  }

  group('LoginPage UI Tests', () {
    testWidgets(
      'UI elements (Inputs and Button) should be displayed correctly',
      (tester) async {
        when(() => mockLoginCubit.state).thenReturn(LoginInitial());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.byType(ElevatedButton), findsOneWidget);
      },
    );

    testWidgets(
      'SnackBar should be shown when logging in with empty fields (Validation)',
      (tester) async {
        when(() => mockLoginCubit.state).thenReturn(LoginInitial());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.at(0), '');
        await tester.enterText(textFields.at(1), '');
        await tester.pump();

        final loginButton = find.byType(ElevatedButton);
        await tester.tap(loginButton);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);

        verifyNever(() => mockLoginCubit.login(any(), any()));
      },
    );

    testWidgets(
      'login method should be called when button is pressed with correct info',
      (tester) async {
        when(() => mockLoginCubit.state).thenReturn(LoginInitial());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        final emailField = textFields.at(0);
        final passwordField = textFields.at(1);

        await tester.enterText(emailField, 'test@example.com');
        await tester.enterText(passwordField, 'password123');
        await tester.pump();

        final loginButton = find.byType(ElevatedButton);
        await tester.tap(loginButton);
        await tester.pump();

        verify(
          () => mockLoginCubit.login('test@example.com', 'password123'),
        ).called(1);
      },
    );

    testWidgets(
      'CircularProgressIndicator should appear instead of button in Loading state',
      (tester) async {
        when(() => mockLoginCubit.state).thenReturn(LoginLoading());

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('SnackBar should be shown in case of error (LoginFailure)', (
      tester,
    ) async {
      whenListen(
        mockLoginCubit,
        Stream.fromIterable([
          LoginLoading(),
          const LoginFailure(ServerFailure(debugMessage: 'User not found')),
        ]),
        initialState: LoginInitial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
