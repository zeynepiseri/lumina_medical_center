import 'package:lumina_medical_center/core/network/api_client.dart';
import '../models/auth_response.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register({
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
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthResponse> login(String email, String password) async {
    final response = await apiClient.post('/auth/authenticate', {
      "email": email,
      "password": password,
    });

    return AuthResponse.fromJson(response);
  }

  @override
  Future<AuthResponse> register({
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
    final response = await apiClient.post('/auth/register', {
      "fullName": fullName,
      "email": email,
      "password": password,
      "nationalId": nationalId,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "birthDate": birthDate,
      "allergies": allergies ?? [],
      "medications": medications ?? [],
      "chronicDiseases": chronicDiseases ?? [],
    });

    return AuthResponse.fromJson(response);
  }
}
