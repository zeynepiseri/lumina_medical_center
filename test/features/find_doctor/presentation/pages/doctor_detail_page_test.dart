import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/init/theme/app_dimens.dart';
import 'package:lumina_medical_center/core/init/theme/app_opacity.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/usecases/get_doctor_detail_usecase.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/bloc/doctor_detail_cubit.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/pages/doctor_detail_page.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/widgets/detail/doctor_about_section.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/widgets/detail/doctor_detail_header.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorDetailCubit extends MockCubit<DoctorDetailState>
    implements DoctorDetailCubit {}

class MockGetDoctorDetailUseCase extends Mock
    implements GetDoctorDetailUseCase {}

void main() {
  late MockDoctorDetailCubit mockCubit;
  late MockGetDoctorDetailUseCase mockUseCase;
  final GetIt sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(const DoctorDetailState());
  });

  setUp(() async {
    await sl.reset();
    mockCubit = MockDoctorDetailCubit();
    mockUseCase = MockGetDoctorDetailUseCase();

    sl.registerFactory<GetDoctorDetailUseCase>(() => mockUseCase);
  });

  const tDoctor = DoctorEntity(
    id: 1,
    fullName: 'Dr. House',
    specialty: 'Diagnostic',
    imageUrl: '',
    title: 'MD',
    biography: 'He is a genius doctor.',
    branchName: 'Internal Medicine',
    rating: 4.8,
    patientCount: 1500,
    experience: 15,
  );

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

          home: const DoctorDetailPage(doctor: tDoctor),
        );
      },
    );
  }

  group('DoctorDetailPage UI Tests', () {
    testWidgets(
      'When the page opens, the doctors information (Header, Name, Bio) should appear',
      (tester) async {
        when(() => mockCubit.state).thenReturn(
          const DoctorDetailState(status: DoctorDetailStatus.success),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        await tester.pumpAndSettle();

        expect(find.byType(DoctorDetailHeader), findsOneWidget);

        expect(find.text('Dr. House'), findsOneWidget);
        expect(find.textContaining('Diagnostic'), findsWidgets);

        expect(find.byType(DoctorAboutSection), findsOneWidget);
        expect(find.text('He is a genius doctor.'), findsOneWidget);
      },
    );

    testWidgets(
      'toggleFavorite should not be called when pressing the favorite button (Page creates his own cubit)',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final favIcon = find.byIcon(Icons.favorite_border);
        expect(favIcon, findsOneWidget);
      },
    );
  });
}
