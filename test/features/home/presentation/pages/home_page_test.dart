import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/init/theme/app_dimens.dart';
import 'package:lumina_medical_center/core/init/theme/app_opacity.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/get_upcoming_appointment_usecase.dart';
import 'package:lumina_medical_center/features/auth/domain/entities/user_entity.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/branches/domain/usecases/get_all_branches_usecase.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/usecases/get_top_doctors_usecase.dart';
import 'package:lumina_medical_center/features/home/presentation/pages/home_page.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTopDoctorsUseCase extends Mock implements GetTopDoctorsUseCase {}

class MockGetUpcomingAppointmentUseCase extends Mock
    implements GetUpcomingAppointmentUseCase {}

class MockGetUserUseCase extends Mock implements GetUserUseCase {}

class MockGetAllBranchesUseCase extends Mock implements GetAllBranchesUseCase {}

class MockUserEntity extends Mock implements UserEntity {}

class MockAppointmentEntity extends Mock implements AppointmentEntity {}

void main() {
  late MockGetTopDoctorsUseCase mockGetTopDoctorsUseCase;
  late MockGetUpcomingAppointmentUseCase mockGetUpcomingAppointmentUseCase;
  late MockGetUserUseCase mockGetUserUseCase;
  late MockGetAllBranchesUseCase mockGetAllBranchesUseCase;
  final GetIt sl = GetIt.instance;

  setUp(() async {
    await sl.reset();
    mockGetTopDoctorsUseCase = MockGetTopDoctorsUseCase();
    mockGetUpcomingAppointmentUseCase = MockGetUpcomingAppointmentUseCase();
    mockGetUserUseCase = MockGetUserUseCase();
    mockGetAllBranchesUseCase = MockGetAllBranchesUseCase();

    sl.registerFactory<GetTopDoctorsUseCase>(() => mockGetTopDoctorsUseCase);
    sl.registerFactory<GetUpcomingAppointmentUseCase>(
      () => mockGetUpcomingAppointmentUseCase,
    );
    sl.registerFactory<GetUserUseCase>(() => mockGetUserUseCase);
    sl.registerFactory<GetAllBranchesUseCase>(() => mockGetAllBranchesUseCase);
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
          home: const HomePage(),
        );
      },
    );
  }

  group('HomePage UI Tests', () {
    testWidgets(
      'The CircularProgressIndicator should appear in the loading state.',
      (tester) async {
        when(() => mockGetTopDoctorsUseCase()).thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 1));
          return const Right([]);
        });
        when(
          () => mockGetUpcomingAppointmentUseCase(),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetUserUseCase()).thenAnswer((_) async {
          final u = MockUserEntity();
          when(() => u.fullName).thenReturn('Test');
          when(() => u.imageUrl).thenReturn('');
          return Right(u);
        });
        when(
          () => mockGetAllBranchesUseCase(),
        ).thenAnswer((_) async => const Right([]));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pumpAndSettle();
      },
    );

    testWidgets('The Dashboard content should appear when the data is loaded', (
      tester,
    ) async {
      final tUser = MockUserEntity();
      when(() => tUser.fullName).thenReturn('Sarah Is');
      when(() => tUser.imageUrl).thenReturn('');

      when(
        () => mockGetTopDoctorsUseCase(),
      ).thenAnswer((_) async => const Right([]));
      when(
        () => mockGetUpcomingAppointmentUseCase(),
      ).thenAnswer((_) async => const Right(null));
      when(() => mockGetUserUseCase()).thenAnswer((_) async => Right(tUser));
      when(() => mockGetAllBranchesUseCase()).thenAnswer(
        (_) async => const Right([
          BranchEntity(
            id: '1',
            name: 'Cardio',
            shortName: 'Cardio',
            imageUrl: '',
          ),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Sarah Is'), findsOneWidget);

      expect(find.text('Cardio'), findsOneWidget);

      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
