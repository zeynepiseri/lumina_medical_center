import 'package:dio/dio.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/admin/data/models/admin_doctor_model.dart';
import 'package:lumina_medical_center/features/admin/data/models/admin_stats_model.dart';
import 'package:lumina_medical_center/features/admin/data/models/specialty_model.dart';

abstract class AdminService {
  Future<AdminStatsModel> getDashboardStats();
  Future<void> addDoctor(Map<String, dynamic> doctorData);
  Future<List<SpecialtyModel>> getSpecialties();
  Future<void> updateDoctor(int id, Map<String, dynamic> doctorData);

  Future<List<AdminDoctorModel>> getAllDoctors();
  Future<AdminDoctorModel> getDoctorById(int id);
}

class AdminServiceImpl implements AdminService {
  final ApiClient _apiClient;

  AdminServiceImpl(this._apiClient);

  @override
  Future<AdminStatsModel> getDashboardStats() async {
    try {
      final response = await _apiClient.get('/admin/dashboard-stats');
      return AdminStatsModel.fromJson(response);
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data['message'] ?? 'Statistics could not be obtained',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'An unexpected Error: $e');
    }
  }

  @override
  Future<void> addDoctor(Map<String, dynamic> doctorData) async {
    try {
      await _apiClient.post('/doctors', doctorData);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Doctor could not be added',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'An unexpected Error: $e');
    }
  }

  @override
  Future<List<SpecialtyModel>> getSpecialties() async {
    try {
      final response = await _apiClient.get('/specialties');

      if (response is List) {
        return response.map((e) => SpecialtyModel.fromJson(e)).toList();
      } else if (response.data is List) {
        return (response.data as List)
            .map((e) => SpecialtyModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data['message'] ?? 'Specialties could not be loaded',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<void> updateDoctor(int id, Map<String, dynamic> doctorData) async {
    try {
      await _apiClient.put('/doctors/$id', doctorData);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Doctor could not be updated',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'An unexpected Error: $e');
    }
  }

  @override
  Future<List<AdminDoctorModel>> getAllDoctors() async {
    try {
      final response = await _apiClient.get('/doctors');

      if (response is List) {
        return response.map((e) => AdminDoctorModel.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to load doctors list',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<AdminDoctorModel> getDoctorById(int id) async {
    try {
      final response = await _apiClient.get('/doctors/$id');
      return AdminDoctorModel.fromJson(response);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to load doctor details',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException({required this.message, this.statusCode});

  @override
  String toString() => message;
}
