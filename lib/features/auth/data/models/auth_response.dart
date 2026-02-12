import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final String accessToken;
  final int userId;
  final String role;
  final String fullName;

  const AuthResponse({
    required this.accessToken,
    required this.userId,
    required this.role,
    required this.fullName,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] ?? '',
      userId: json['user_id'] ?? 0,
      role: json['role'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'user_id': userId,
      'role': role,
      'full_name': fullName,
    };
  }

  @override
  List<Object?> get props => [accessToken, userId, role, fullName];
}
