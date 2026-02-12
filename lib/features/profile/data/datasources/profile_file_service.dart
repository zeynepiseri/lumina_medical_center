import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:lumina_medical_center/core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileFileService {
  final Dio _dio;
  final SharedPreferences _prefs;

  ProfileFileService(this._dio, this._prefs);

  Future<String?> uploadProfileImage(File file) async {
    try {
      final token = _prefs.getString('auth_token');

      String fileName = file.path.split('/').last;
      if (!fileName.toLowerCase().contains('.')) {
        fileName = "$fileName.jpg";
      }

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final response = await _dio.post(
        '${NetworkConstants.apiBaseUrl}/api/files/upload',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['downloadURL'] != null) {
          return data['downloadURL'].toString();
        } else {
          throw Exception(
            "The upload was successful, but the 'downloadURL' is missing.",
          );
        }
      } else {
        throw Exception(
          "Upload Failed: ${response.statusCode} - ${response.statusMessage}",
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
