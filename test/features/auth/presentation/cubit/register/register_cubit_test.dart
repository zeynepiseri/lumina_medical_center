import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/register_usecase.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/register/register_state.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late RegisterCubit registerCubit;
  late MockRegisterUseCase mockRegisterUseCase;

  const tFullName = 'Zeynep Iseri';
  const tEmail = 'zeynep@example.com';
  const tPassword = 'password123';
  const tNationalId = '11122233344';
  const tPhoneNumber = '5551234567';
  const tGender = 'Female';
  final tBirthDate = DateTime(1995, 5, 20);
  const tChronic = 'None';
  const tAllergies = 'Pollen';
  const tMedications = 'None';

  setUpAll(() {
    registerFallbackValue(
      RegisterParams(
        fullName: '',
        email: '',
        password: '',
        nationalId: '',
        rawPhoneNumber: '',
        gender: '',
        birthDate: DateTime.now(),
        chronicDiseasesText: '',
        allergiesText: '',
        medicationsText: '',
      ),
    );
  });

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    registerCubit = RegisterCubit(registerUseCase: mockRegisterUseCase);
  });

  tearDown(() {
    registerCubit.close();
  });

  group('RegisterCubit Tests', () {
    test('Initial state should be RegisterInitial', () {
      expect(registerCubit.state, equals(RegisterInitial()));
    });

    blocTest<RegisterCubit, RegisterState>(
      'should emit [RegisterLoading, RegisterSuccess] when registration is successful',
      build: () {
        when(
          () => mockRegisterUseCase(any()),
        ).thenAnswer((_) async => const Right(null));
        return registerCubit;
      },
      act: (cubit) => cubit.register(
        fullName: tFullName,
        email: tEmail,
        password: tPassword,
        nationalId: tNationalId,
        rawPhoneNumber: tPhoneNumber,
        gender: tGender,
        birthDate: tBirthDate,
        chronicDiseasesText: tChronic,
        allergiesText: tAllergies,
        medicationsText: tMedications,
      ),
      expect: () => [RegisterLoading(), RegisterSuccess()],
      verify: (_) {
        verify(
          () => mockRegisterUseCase(
            any(
              that: isA<RegisterParams>()
                  .having((p) => p.email, 'email', tEmail)
                  .having((p) => p.fullName, 'name', tFullName),
            ),
          ),
        ).called(1);
      },
    );

    blocTest<RegisterCubit, RegisterState>(
      'should emit [RegisterLoading, RegisterFailure] when registration fails',
      build: () {
        when(() => mockRegisterUseCase(any())).thenAnswer(
          (_) async => const Left(ServerFailure(debugMessage: 'Email exists')),
        );
        return registerCubit;
      },
      act: (cubit) => cubit.register(
        fullName: tFullName,
        email: tEmail,
        password: tPassword,
        nationalId: tNationalId,
        rawPhoneNumber: tPhoneNumber,
        gender: tGender,
        birthDate: tBirthDate,
        chronicDiseasesText: tChronic,
        allergiesText: tAllergies,
        medicationsText: tMedications,
      ),
      expect: () => [
        RegisterLoading(),
        RegisterFailure(const ServerFailure(debugMessage: 'Email exists')),
      ],
    );
  });
}
