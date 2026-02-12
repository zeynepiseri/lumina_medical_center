import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/data/models/my_profile_model.dart';

class DoctorProfileService {
  final ApiClient _client;

  DoctorProfileService(this._client);

  Future<MyProfileModel> getMyProfile(int userId) async {
    final response = await _client.get('/doctors/$userId');
    return MyProfileModel.fromJson(response);
  }

  Future<void> updateProfile({
    required int userId,
    required String biography,
    required int experience,
    required List<Map<String, dynamic>> schedules,
    required List<String> subSpecialties,
    required List<String> educations,
    String? imageUrl,
  }) async {
    final Map<String, dynamic> data = {
      'biography': biography,
      'experience': experience,
      'schedules': schedules,
      'subSpecialties': subSpecialties,
      'educations': educations,
    };

    if (imageUrl != null) {
      data['imageUrl'] = imageUrl;
    }

    await _client.put('/doctors/$userId', data);
  }
}
