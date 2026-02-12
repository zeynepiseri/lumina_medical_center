import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, void>> call(RegisterParams params) async {
    return await _repository.register(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
      nationalId: params.nationalId,

      phoneNumber: params.formattedPhoneNumber,
      gender: params.gender,
      birthDate: params.formattedBirthDate,
      allergies: params.allergiesList,
      medications: params.medicationsList,
      chronicDiseases: params.chronicDiseasesList,
    );
  }
}

class RegisterParams extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String nationalId;
  final String rawPhoneNumber;
  final String gender;
  final DateTime birthDate;
  final String chronicDiseasesText;
  final String allergiesText;
  final String medicationsText;

  const RegisterParams({
    required this.fullName,
    required this.email,
    required this.password,
    required this.nationalId,
    required this.rawPhoneNumber,
    required this.gender,
    required this.birthDate,
    required this.chronicDiseasesText,
    required this.allergiesText,
    required this.medicationsText,
  });

  String get formattedPhoneNumber =>
      rawPhoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

  String get formattedBirthDate =>
      "${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}";

  List<String> get chronicDiseasesList => _splitAndTrim(chronicDiseasesText);
  List<String> get allergiesList => _splitAndTrim(allergiesText);
  List<String> get medicationsList => _splitAndTrim(medicationsText);

  List<String> _splitAndTrim(String text) {
    if (text.isEmpty) return [];
    return text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  @override
  List<Object?> get props => [email, nationalId, rawPhoneNumber];
}
