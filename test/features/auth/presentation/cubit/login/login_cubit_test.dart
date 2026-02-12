import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/login_usecase.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/login/login_state.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late LoginCubit loginCubit;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    loginCubit = LoginCubit(loginUseCase: mockLoginUseCase);
  });

  tearDown(() {
    loginCubit.close();
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tRole = 'doctor';

  group('LoginCubit Tests', () {
    test('Initial state should be LoginInitial', () {
      expect(loginCubit.state, equals(LoginInitial()));
    });

    blocTest<LoginCubit, LoginState>(
      'should emit [LoginLoading, LoginSuccess] when login is successful',
      build: () {
        when(
          () => mockLoginUseCase(tEmail, tPassword),
        ).thenAnswer((_) async => const Right(tRole));
        return loginCubit;
      },
      act: (cubit) => cubit.login(tEmail, tPassword),
      expect: () => [LoginLoading(), const LoginSuccess(tRole)],
      verify: (_) {
        verify(() => mockLoginUseCase(tEmail, tPassword)).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'should emit [LoginLoading, LoginFailure] when login fails',
      build: () {
        when(() => mockLoginUseCase(tEmail, tPassword)).thenAnswer(
          (_) async =>
              const Left(ServerFailure(debugMessage: 'Invalid Credentials')),
        );
        return loginCubit;
      },
      act: (cubit) => cubit.login(tEmail, tPassword),
      expect: () => [
        LoginLoading(),
        const LoginFailure(ServerFailure(debugMessage: 'Invalid Credentials')),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(tEmail, tPassword)).called(1);
      },
    );
  });
}
