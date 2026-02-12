import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/features/patient/data/models/patient_model.dart';
import 'package:lumina_medical_center/features/patient/domain/entities/patient_entity.dart';

void main() {
  const tPatientModel = PatientModel(
    id: 1,
    fullName: 'Test Patient',
    email: 'test@lumina.com',
    height: 180.0,
    weight: 75.0,
    bloodType: 'A+',
    chronicDiseases: ['Asthma'],
  );

  group('PatientModel', () {
    test('The Entity class must have a subclass', () {
      expect(tPatientModel, isA<PatientEntity>());
    });

    group('fromJson', () {
      test('It should return a valid model when the JSON data arrives', () {
        final Map<String, dynamic> jsonMap = {
          "id": 1,
          "fullName": "Test Patient",
          "email": "test@lumina.com",
          "height": 180.0,
          "weight": 75.0,
          "bloodType": "A+",
          "chronicDiseases": ["Asthma"],
          "allergies": [],
        };

        final result = PatientModel.fromJson(jsonMap);

        expect(result, tPatientModel);
      });

      test(
        'Even if Weight or Height is passed as an integer, it should be processed as a double.',
        () {
          final Map<String, dynamic> jsonMap = {
            "id": 1,
            "fullName": "Test Patient",
            "email": "test@lumina.com",
            "height": 180,
            "weight": 75,
          };

          final result = PatientModel.fromJson(jsonMap);

          expect(result.height, 180.0);
          expect(result.weight, 75.0);
        },
      );
    });

    group('toJson', () {
      test('Convert the model to an accurate JSON map format', () {
        final result = tPatientModel.toJson();

        final expectedMap = {
          "id": 1,
          "fullName": "Test Patient",
          "email": "test@lumina.com",
          "phoneNumber": null,
          "nationalId": null,
          "imageUrl": null,
          "gender": null,
          "birthDate": null,
          "height": 180.0,
          "weight": 75.0,
          "bloodType": "A+",
          "chronicDiseases": ["Asthma"],
          "allergies": [],
        };
        expect(result, expectedMap);
      });
    });
  });
}
