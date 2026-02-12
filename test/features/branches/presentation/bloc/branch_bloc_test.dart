import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/branches/domain/usecases/get_all_branches_usecase.dart';
import 'package:lumina_medical_center/features/branches/presentation/bloc/branch_bloc.dart';
import 'package:lumina_medical_center/features/branches/presentation/bloc/branch_event.dart';
import 'package:lumina_medical_center/features/branches/presentation/bloc/branch_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllBranchesUseCase extends Mock implements GetAllBranchesUseCase {}

void main() {
  late BranchBloc branchBloc;
  late MockGetAllBranchesUseCase mockGetAllBranchesUseCase;

  setUp(() {
    mockGetAllBranchesUseCase = MockGetAllBranchesUseCase();
    branchBloc = BranchBloc(getAllBranchesUseCase: mockGetAllBranchesUseCase);
  });

  tearDown(() {
    branchBloc.close();
  });

  final tBranches = [
    const BranchEntity(
      id: '1',
      name: 'Cardiology',
      shortName: 'Cardio',
      imageUrl: 'url1',
    ),
    const BranchEntity(
      id: '2',
      name: 'Neurology',
      shortName: 'Neuro',
      imageUrl: 'url2',
    ),
  ];

  group('BranchBloc Tests', () {
    test('Initial state should be BranchInitial', () {
      expect(branchBloc.state, equals(BranchInitial()));
    });

    blocTest<BranchBloc, BranchState>(
      'should emit [BranchLoading, BranchLoaded] when branches are loaded successfully',
      build: () {
        when(
          () => mockGetAllBranchesUseCase(),
        ).thenAnswer((_) async => Right(tBranches));
        return branchBloc;
      },
      act: (bloc) => bloc.add(LoadBranchesEvent()),
      expect: () => [BranchLoading(), BranchLoaded(tBranches)],
      verify: (_) {
        verify(() => mockGetAllBranchesUseCase()).called(1);
      },
    );

    blocTest<BranchBloc, BranchState>(
      'should emit [BranchLoading, BranchError] on error',
      build: () {
        when(() => mockGetAllBranchesUseCase()).thenAnswer(
          (_) async => const Left(ServerFailure(debugMessage: 'API Error')),
        );
        return branchBloc;
      },
      act: (bloc) => bloc.add(LoadBranchesEvent()),
      expect: () => [BranchLoading(), isA<BranchError>()],
      verify: (_) {
        verify(() => mockGetAllBranchesUseCase()).called(1);
      },
    );
  });
}
