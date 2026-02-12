import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserSession({
    required String token,
    required String role,
    required String fullName,
    required int userId,
  });
  Future<String?> getToken();
  Future<String?> getUserRole();
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  static const String _tokenKey = 'token';
  static const String _roleKey = 'role';
  static const String _nameKey = 'fullName';
  static const String _idKey = 'userId';

  @override
  Future<void> saveUserSession({
    required String token,
    required String role,
    required String fullName,
    required int userId,
  }) async {
    await sharedPreferences.setString(_tokenKey, token);
    await sharedPreferences.setString(_roleKey, role);
    await sharedPreferences.setString(_nameKey, fullName);
    await sharedPreferences.setInt(_idKey, userId);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<String?> getUserRole() async {
    return sharedPreferences.getString(_roleKey);
  }

  @override
  Future<void> clearSession() async {
    await sharedPreferences.clear();
  }
}
