import 'package:lumina_medical_center/core/network/api_client.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getCurrentUser();
  Future<bool> updateProfilePhoto(String imageUrl);
  Future<void> changePassword(String currentPassword, String newPassword);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSourceImpl(this._apiClient);

  final String _usersEndpoint = '/users';

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get('$_usersEndpoint/me');

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception("Could not fetch user info: $e");
    }
  }

  @override
  Future<bool> updateProfilePhoto(String imageUrl) async {
    try {
      await _apiClient.patch('$_usersEndpoint/photo', {"imageUrl": imageUrl});
      return true;
    } catch (e) {
      throw Exception("Could not update photo: $e");
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _apiClient.post('$_usersEndpoint/change-password', {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      });
    } catch (e) {
      rethrow;
    }
  }
}
