import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/get_user_role_usecase.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserRoleUseCase extends Mock implements GetUserRoleUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late AuthCubit authCubit;
  late MockGetUserRoleUseCase mockGetUserRoleUseCase;
  late MockLogoutUseCase mockLogoutUseCase;

  setUp(() {
    mockGetUserRoleUseCase = MockGetUserRoleUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    authCubit = AuthCubit(
      getUserRoleUseCase: mockGetUserRoleUseCase,
      logoutUseCase: mockLogoutUseCase,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit Tests', () {
    test('Initial state should be AuthInitial', () {
      expect(authCubit.state, equals(AuthInitial()));
    });

    group('checkAuthStatus', () {
      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, Authenticated] if user role exists',
        build: () {
          when(
            () => mockGetUserRoleUseCase(),
          ).thenAnswer((_) async => const Right('doctor'));
          return authCubit;
        },
        act: (cubit) => cubit.checkAuthStatus(),
        expect: () => [AuthLoading(), const Authenticated('doctor')],
        verify: (_) {
          verify(() => mockGetUserRoleUseCase()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, Unauthenticated] if user role is missing (null)',
        build: () {
          when(
            () => mockGetUserRoleUseCase(),
          ).thenAnswer((_) async => const Right(null));
          return authCubit;
        },
        act: (cubit) => cubit.checkAuthStatus(),
        expect: () => [AuthLoading(), Unauthenticated()],
      );

      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, Unauthenticated] in case of error',
        build: () {
          when(() => mockGetUserRoleUseCase()).thenAnswer(
            (_) async => const Left(ServerFailure(debugMessage: 'No user')),
          );
          return authCubit;
        },
        act: (cubit) => cubit.checkAuthStatus(),
        expect: () => [AuthLoading(), Unauthenticated()],
      );
    });

    group('logout', () {
      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, Unauthenticated] when logging out',
        build: () {
          when(
            () => mockLogoutUseCase(),
          ).thenAnswer((_) async => const Right(null));
          return authCubit;
        },
        act: (cubit) => cubit.logout(),
        expect: () => [AuthLoading(), Unauthenticated()],
        verify: (_) {
          verify(() => mockLogoutUseCase()).called(1);
        },
      );
    });

    group('loggedIn', () {
      blocTest<AuthCubit, AuthState>(
        'should emit [Authenticated] when loggedIn is called',
        build: () => authCubit,
        act: (cubit) => cubit.loggedIn('patient'),
        expect: () => [const Authenticated('patient')],
      );
    });
  });
}
