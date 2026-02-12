import 'package:lumina_medical_center/core/network/api_client.dart';
import '../models/doctor_model.dart';

class DoctorService {
  final ApiClient _client;

  DoctorService(this._client);

  Future<List<DoctorModel>> getDoctors({String? branchId}) async {
    try {
      final String path = branchId != null
          ? '/doctors?branchId=$branchId'
          : '/doctors';
      final response = await _client.get(path);
      return (response as List)
          .map((json) => DoctorModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Doctors could not be fetched: $e");
    }
  }

  Future<DoctorModel> getDoctorById(int id) async {
    try {
      final response = await _client.get('/doctors/$id');
      return DoctorModel.fromJson(response);
    } catch (e) {
      throw Exception("Doctor information could not be obtained: $e");
    }
  }
}
