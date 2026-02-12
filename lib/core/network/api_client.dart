import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerException implements Exception {
  final String? code;
  final String? message;
  final int? statusCode;
  ServerException({this.code, this.message, this.statusCode});

  @override
  String toString() => message ?? "Server Error";
}

class ApiClient {
  final Dio _dio;
  final SharedPreferences _prefs;

  ApiClient(this._dio, this._prefs);

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint, options: _getOptions());
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> post(String endpoint, dynamic data) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: _getOptions(),
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        options: _getOptions(),
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint, options: _getOptions());
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> patch(String endpoint, dynamic data) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        options: _getOptions(),
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Options _getOptions() {
    final token = _prefs.getString('token');
    if (token != null) {
      return Options(headers: {'Authorization': 'Bearer $token'});
    }
    return Options();
  }

  void _handleError(DioException e) {
    String? serverMessage;
    String? serverCode;

    if (e.response != null && e.response!.data != null) {
      final data = e.response!.data;
      if (data is Map) {
        serverMessage = data['message']?.toString();
        serverCode = data['code']?.toString();
      } else {
        serverMessage = data.toString();
      }
    } else {
      serverMessage = e.message;
    }

    throw ServerException(
      message: serverMessage,
      code: serverCode,
      statusCode: e.response?.statusCode,
    );
  }
}
