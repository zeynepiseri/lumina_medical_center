import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login(String email, String password);

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
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, String?>> getUserRole();
}
