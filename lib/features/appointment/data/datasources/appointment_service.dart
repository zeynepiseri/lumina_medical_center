import 'package:dio/dio.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/appointment/data/models/appointment_model.dart';

class AppointmentService {
  final ApiClient _client;

  AppointmentService(this._client);

  List<AppointmentModel> _parseList(dynamic response) {
    if (response is List) {
      return response.map((json) => AppointmentModel.fromJson(json)).toList();
    } else if (response is Response) {
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((json) => AppointmentModel.fromJson(json))
            .toList();
      }
    }
    return [];
  }

  Future<List<AppointmentModel>> getMyAppointments() async {
    try {
      final response = await _client.get('/appointments/my');
      return _parseList(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AppointmentModel>> getAllAppointmentsForAdmin() async {
    try {
      final response = await _client.get('/appointments');
      return _parseList(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AppointmentModel>> getAppointmentsByDate(DateTime date) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final response = await _client.get('/appointments/by-date?date=$dateStr');
      return _parseList(response);
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteAppointment(int id) async {
    try {
      await _client.delete('/appointments/$id');
      return true;
    } catch (e) {
      throw Exception('Failed to delete appointment: $e');
    }
  }

  Future<bool> createAppointment(
    int doctorId,
    DateTime appointmentTime,
    String type,
    String? consultationMethod,
  ) async {
    try {
      await _client.post('/appointments', {
        'doctorId': doctorId,
        'appointmentTime': appointmentTime.toIso8601String(),
        'appointmentType': type,
        'consultationMethod': consultationMethod,
        'status': 'Upcoming',
      });
      return true;
    } catch (e) {
      throw Exception('Failed to create appointment: $e');
    }
  }

  Future<bool> rescheduleAppointment(
    int appointmentId,
    DateTime newDate,
  ) async {
    try {
      await _client.put('/appointments/$appointmentId', {
        'appointmentTime': newDate.toIso8601String(),
      });
      return true;
    } catch (e) {
      throw Exception('Failed to reschedule appointment: $e');
    }
  }

  Future<bool> updateAppointment(
    int appointmentId,
    DateTime newDate,
    String type,
    String? consultationMethod,
  ) async {
    try {
      await _client.put('/appointments/$appointmentId', {
        'appointmentTime': newDate.toIso8601String(),
        'appointmentType': type,
        'consultationMethod': consultationMethod,
      });
      return true;
    } catch (e) {
      throw Exception('Failed to update appointment: $e');
    }
  }

  Future<List<DateTime>> getBookedSlots(int doctorId) async {
    return [];
  }
}
