import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/init/theme/app_dimens.dart';
import 'package:lumina_medical_center/core/init/theme/app_opacity.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/branches/presentation/bloc/branch_bloc.dart';
import 'package:lumina_medical_center/features/branches/presentation/bloc/branch_event.dart';
import 'package:lumina_medical_center/features/branches/presentation/bloc/branch_state.dart';
import 'package:lumina_medical_center/features/branches/presentation/pages/branches_page.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockBranchBloc extends MockBloc<BranchEvent, BranchState>
    implements BranchBloc {}

class FakeBranchEvent extends Fake implements BranchEvent {}

class FakeBranchState extends Fake implements BranchState {}

void main() {
  late MockBranchBloc mockBranchBloc;
  final GetIt sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(FakeBranchEvent());
    registerFallbackValue(FakeBranchState());
  });

  setUp(() async {
    mockBranchBloc = MockBranchBloc();
    await sl.reset();
    sl.registerFactory<BranchBloc>(() => mockBranchBloc);
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
          home: const BranchesPage(),
        );
      },
    );
  }

  group('BranchesPage UI Tests', () {
    testWidgets('should display CircularProgressIndicator when loading', (
      tester,
    ) async {
      when(() => mockBranchBloc.state).thenReturn(BranchLoading());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message and icon on error', (
      tester,
    ) async {
      const errorMessage = 'An error occurred';
      when(() => mockBranchBloc.state).thenReturn(BranchError(errorMessage));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('should display branch list (Grid) when loaded', (
      tester,
    ) async {
      final branches = [
        const BranchEntity(
          id: '1',
          name: 'Cardiology',
          shortName: 'Cardio',
          imageUrl: '',
        ),
        const BranchEntity(
          id: '2',
          name: 'Neurology',
          shortName: 'Neuro',
          imageUrl: '',
        ),
      ];
      when(() => mockBranchBloc.state).thenReturn(BranchLoaded(branches));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Cardiology'), findsOneWidget);
      expect(find.text('Neurology'), findsOneWidget);

      expect(find.byType(SvgPicture), findsNWidgets(2));
    });
  });
}
