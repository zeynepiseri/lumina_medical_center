import '../../domain/entities/patient_entity.dart';

class PatientModel extends PatientEntity {
  const PatientModel({
    required int id,
    required String fullName,
    required String email,
    String? phoneNumber,
    String? nationalId,
    String? imageUrl,
    String? gender,
    DateTime? birthDate,
    double? height,
    double? weight,
    String? bloodType,
    List<String> allergies = const [],
    List<String> chronicDiseases = const [],
  }) : super(
         id: id,
         fullName: fullName,
         email: email,
         phoneNumber: phoneNumber,
         nationalId: nationalId,
         imageUrl: imageUrl,
         gender: gender,
         birthDate: birthDate,
         height: height,
         weight: weight,
         bloodType: bloodType,
         allergies: allergies,
         chronicDiseases: chronicDiseases,
       );

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      nationalId: json['nationalId'],
      imageUrl: json['imageUrl'],
      gender: json['gender'],
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      bloodType: json['bloodType'],
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : [],
      chronicDiseases: json['chronicDiseases'] != null
          ? List<String>.from(json['chronicDiseases'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'nationalId': nationalId,
      'imageUrl': imageUrl,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
      'height': height,
      'weight': weight,
      'bloodType': bloodType,
      'allergies': allergies,
      'chronicDiseases': chronicDiseases,
    };
  }
}
