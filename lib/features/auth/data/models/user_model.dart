import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.phoneNumber,
    super.nationalId,
    super.imageUrl,
    super.gender,
    super.birthDate,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      nationalId: json['nationalId'],
      imageUrl: json['imageUrl'],
      gender: json['gender'],
      birthDate: json['birthDate']?.toString(),
      role: _parseRole(json['role']),
    );
  }

  static String _parseRole(dynamic roleData) {
    if (roleData is String) return roleData;
    if (roleData is Map && roleData.containsKey('name'))
      return roleData['name'];
    return 'PATIENT';
  }
}
