import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:lumina_medical_center/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lumina_medical_center/features/auth/data/models/auth_response.dart';
import 'package:lumina_medical_center/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/register_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tEmail = 'test@test.com';
  const tPassword = 'password';
  const tRole = 'doctor';
  const tToken = 'jwt_token';
  const tUserId = 1;
  const tFullName = 'Dr. Test';

  final tAuthResponse = const AuthResponse(
    accessToken: tToken,
    userId: tUserId,
    role: tRole,
    fullName: tFullName,
  );

  group('AuthRepositoryImpl Tests', () {
    group('login', () {
      test(
        'Session should be saved and role returned on successful login',
        () async {
          when(
            () => mockRemoteDataSource.login(tEmail, tPassword),
          ).thenAnswer((_) async => tAuthResponse);

          when(
            () => mockLocalDataSource.saveUserSession(
              token: tToken,
              role: tRole,
              fullName: tFullName,
              userId: tUserId,
            ),
          ).thenAnswer((_) async => {});

          final result = await repository.login(tEmail, tPassword);

          verify(() => mockRemoteDataSource.login(tEmail, tPassword)).called(1);
          verify(
            () => mockLocalDataSource.saveUserSession(
              token: tToken,
              role: tRole,
              fullName: tFullName,
              userId: tUserId,
            ),
          ).called(1);

          expect(result, equals(const Right(tRole)));
        },
      );

      test('should return ServerFailure in case of API error', () async {
        when(
          () => mockRemoteDataSource.login(tEmail, tPassword),
        ).thenThrow(ServerException(message: 'Login Failed'));

        final result = await repository.login(tEmail, tPassword);

        verifyZeroInteractions(mockLocalDataSource);
        expect(
          result,
          equals(const Left(ServerFailure(debugMessage: 'Login Failed'))),
        );
      });
    });

    group('register', () {
      final tParams = RegisterParams(
        fullName: 'Test',
        email: tEmail,
        password: tPassword,
        nationalId: '123',
        rawPhoneNumber: '555',
        gender: 'M',
        birthDate: DateTime.now(),
        chronicDiseasesText: '',
        allergiesText: '',
        medicationsText: '',
      );

      test('should return Right(void) if registration is successful', () async {
        when(
          () => mockLocalDataSource.clearSession(),
        ).thenAnswer((_) async => {});

        when(
          () => mockRemoteDataSource.register(
            fullName: tParams.fullName,
            email: tParams.email,
            password: tParams.password,
            nationalId: tParams.nationalId,
            phoneNumber: tParams.formattedPhoneNumber,
            gender: tParams.gender,
            birthDate: tParams.formattedBirthDate,
            allergies: any(named: 'allergies'),
            medications: any(named: 'medications'),
            chronicDiseases: any(named: 'chronicDiseases'),
          ),
        ).thenAnswer((_) async => tAuthResponse);

        when(
          () => mockLocalDataSource.saveUserSession(
            token: tToken,
            role: tRole,
            fullName: tFullName,
            userId: tUserId,
          ),
        ).thenAnswer((_) async => {});

        final result = await repository.register(
          fullName: tParams.fullName,
          email: tParams.email,
          password: tParams.password,
          nationalId: tParams.nationalId,
          phoneNumber: tParams.formattedPhoneNumber,
          gender: tParams.gender,
          birthDate: tParams.formattedBirthDate,
          allergies: tParams.allergiesList,
          medications: tParams.medicationsList,
          chronicDiseases: tParams.chronicDiseasesList,
        );

        verify(() => mockLocalDataSource.clearSession()).called(1);

        verify(
          () => mockRemoteDataSource.register(
            fullName: tParams.fullName,
            email: tParams.email,
            password: tParams.password,
            nationalId: tParams.nationalId,
            phoneNumber: tParams.formattedPhoneNumber,
            gender: tParams.gender,
            birthDate: tParams.formattedBirthDate,
            allergies: any(named: 'allergies'),
            medications: any(named: 'medications'),
            chronicDiseases: any(named: 'chronicDiseases'),
          ),
        ).called(1);

        verify(
          () => mockLocalDataSource.saveUserSession(
            token: tToken,
            role: tRole,
            fullName: tFullName,
            userId: tUserId,
          ),
        ).called(1);

        expect(result.isRight(), true);
      });
    });

    group('logout', () {
      test('Local data should be cleared when logging out', () async {
        when(
          () => mockLocalDataSource.clearSession(),
        ).thenAnswer((_) async => {});

        final result = await repository.logout();

        verify(() => mockLocalDataSource.clearSession()).called(1);
        expect(result, equals(const Right(null)));
      });
    });

    group('getUserRole', () {
      test('Role should be read successfully from local storage', () async {
        when(
          () => mockLocalDataSource.getUserRole(),
        ).thenAnswer((_) async => tRole);

        final result = await repository.getUserRole();

        verify(() => mockLocalDataSource.getUserRole()).called(1);
        expect(result, equals(const Right(tRole)));
      });
    });
  });
}
