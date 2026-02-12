import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:lumina_medical_center/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lumina_medical_center/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<Failure, String>> login(String email, String password) async {
    try {
      final response = await _remoteDataSource.login(email, password);

      await _localDataSource.saveUserSession(
        token: response.accessToken,
        role: response.role,
        fullName: response.fullName,
        userId: response.userId,
      );

      return Right(response.role);
    } catch (e) {
      return Left(
        ServerFailure(debugMessage: e.toString().replaceAll("Exception: ", "")),
      );
    }
  }

  @override
  Future<Either<Failure, void>> register({
    required String fullName,
    required String email,
    required String password,
    required String nationalId,
    required String phoneNumber,
    required String gender,
    required String birthDate,
    List<String>? allergies,
    List<String>? medications,
    List<String>? chronicDiseases,
  }) async {
    try {
      await _localDataSource.clearSession();

      final response = await _remoteDataSource.register(
        fullName: fullName,
        email: email,
        password: password,
        nationalId: nationalId,
        phoneNumber: phoneNumber,
        gender: gender,
        birthDate: birthDate,
        allergies: allergies,
        medications: medications,
        chronicDiseases: chronicDiseases,
      );

      if (response.accessToken.isNotEmpty) {
        await _localDataSource.saveUserSession(
          token: response.accessToken,
          role: response.role,
          fullName: response.fullName,
          userId: response.userId,
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(debugMessage: e.toString().replaceAll("Exception: ", "")),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearSession();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getUserRole() async {
    try {
      final role = await _localDataSource.getUserRole();
      return Right(role);
    } catch (e) {
      return Left(ServerFailure(debugMessage: e.toString()));
    }
  }
}
