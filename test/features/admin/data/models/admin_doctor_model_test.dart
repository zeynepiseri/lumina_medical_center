import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/features/admin/data/models/admin_doctor_model.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';

void main() {
  const tAdminDoctorModel = AdminDoctorModel(
    id: 1,
    fullName: 'Dr. Test',
    title: 'Prof.',
    specialty: 'Cardiology',
    imageUrl: 'url',
    biography: 'Bio',
    experience: 10,
    patientCount: 100,
    rating: 4.5,
    reviewCount: 10,
    email: 'test@doc.com',
    phoneNumber: '123456',
    nationalId: '111',
    gender: 'Male',
    diplomaNo: 'DIP123',
    birthDate: '1980',
    subSpecialties: ['Hypertension'],
    professionalExperiences: [],
    educations: [],
    acceptedInsurances: [],
    schedules: [],
  );

  group('AdminDoctorModel', () {
    test('should be a subclass of the Entity class', () {
      expect(tAdminDoctorModel, isA<AdminDoctorEntity>());
    });

    group('fromJson', () {
      test('should return correct model when full JSON is received', () {
        final Map<String, dynamic> jsonMap = {
          "id": 1,
          "fullName": "Dr. Test",
          "title": "Prof.",
          "specialty": "Cardiology",
          "imageUrl": "url",
          "biography": "Bio",
          "experience": 10,
          "patientCount": 100,
          "rating": 4.5,
          "reviewCount": 10,
          "email": "test@doc.com",
          "phoneNumber": "123456",
          "nationalId": "111",
          "gender": "Male",
          "diplomaNo": "DIP123",
          "birthDate": "1980",
          "subSpecialties": ["Hypertension"],
          "professionalExperiences": [],
          "educations": [],
          "acceptedInsurances": [],
          "schedules": [],
        };

        final result = AdminDoctorModel.fromJson(jsonMap);

        expect(result, tAdminDoctorModel);
      });

      test(
        'should return default values when fields are missing or Null (Should not crash)',
        () {
          final Map<String, dynamic> jsonMap = {"id": 1};

          final result = AdminDoctorModel.fromJson(jsonMap);

          expect(result.id, 1);
          expect(result.fullName, 'Unknown');
          expect(result.rating, 0.0);
          expect(result.schedules, isEmpty);
        },
      );

      test('Nested Lists (Schedules) should be parsed correctly', () {
        final Map<String, dynamic> jsonMap = {
          "id": 1,
          "schedules": [
            {
              "id": 10,
              "dayOfWeek": "MONDAY",
              "startTime": "09:00",
              "endTime": "17:00",
            },
          ],
        };

        final result = AdminDoctorModel.fromJson(jsonMap);

        expect(result.schedules.length, 1);
        expect(result.schedules.first.dayOfWeek, 'MONDAY');
      });
    });
  });
}
