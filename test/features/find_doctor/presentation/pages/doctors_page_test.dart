import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/init/theme/app_dimens.dart';
import 'package:lumina_medical_center/core/init/theme/app_opacity.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/usecases/get_doctors_usecase.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/pages/doctors_page.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDoctorsUseCase extends Mock implements GetDoctorsUseCase {}

void main() {
  late MockGetDoctorsUseCase mockUseCase;
  final GetIt sl = GetIt.instance;

  setUp(() async {
    await sl.reset();
    mockUseCase = MockGetDoctorsUseCase();

    sl.registerFactory<GetDoctorsUseCase>(() => mockUseCase);
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
          home: const DoctorsPage(branchId: '1', branchName: 'Cardiology'),
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
    branchName: 'Cardiology',
    rating: 4.5,
    patientCount: 100,
  );

  group('DoctorsPage UI Tests', () {
    testWidgets('Should show CircularProgressIndicator while loading', (
      tester,
    ) async {
      when(() => mockUseCase(branchId: '1')).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return const Right([tDoctor]);
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('Should show doctor list when data is loaded', (tester) async {
      when(
        () => mockUseCase(branchId: '1'),
      ).thenAnswer((_) async => const Right([tDoctor]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('MD Dr. House'), findsOneWidget);
      expect(find.text('Diagnostic'), findsOneWidget);
    });

    testWidgets('Should show empty view when list is empty', (tester) async {
      when(
        () => mockUseCase(branchId: '1'),
      ).thenAnswer((_) async => const Right([]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.medical_services_outlined), findsOneWidget);
    });
  });
}
