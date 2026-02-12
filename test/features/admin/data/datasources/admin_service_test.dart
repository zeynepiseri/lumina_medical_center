import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';

import 'package:lumina_medical_center/features/admin/data/datasources/admin_service.dart'
    as service_lib;
import 'package:lumina_medical_center/features/admin/data/datasources/admin_service.dart'
    hide ServerException;

import 'package:lumina_medical_center/features/admin/data/models/admin_doctor_model.dart';
import 'package:lumina_medical_center/features/admin/data/models/admin_stats_model.dart';
import 'package:lumina_medical_center/features/admin/data/models/specialty_model.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late AdminServiceImpl service;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    service = AdminServiceImpl(mockApiClient);
  });

  group('AdminService Tests', () {
    final tStatsJson = {
      "totalDoctors": 10,
      "totalPatients": 100,
      "totalAppointments": 500,
      "monthlyEarnings": 15000.0,
      "monthlyAppointmentsData": [10, 20, 30],
      "monthLabels": ["Jan", "Feb", "Mar"],
      "topDoctorName": "Dr. Best",
      "topDoctorBranch": "Cardio",
      "topDoctors": [],
    };

    test('getDashboardStats should return AdminStatsModel', () async {
      when(
        () => mockApiClient.get('/admin/dashboard-stats'),
      ).thenAnswer((_) async => tStatsJson);

      final result = await service.getDashboardStats();

      verify(() => mockApiClient.get('/admin/dashboard-stats')).called(1);
      expect(result, isA<AdminStatsModel>());
      expect(result.totalDoctors, 10);
      expect(result.monthlyEarnings, 15000.0);
    });

    test('addDoctor should call POST /doctors', () async {
      final tData = {"name": "New Doc"};
      when(() => mockApiClient.post('/doctors', tData)).thenAnswer(
        (_) async =>
            Response(requestOptions: RequestOptions(path: ''), statusCode: 201),
      );

      await service.addDoctor(tData);

      verify(() => mockApiClient.post('/doctors', tData)).called(1);
    });

    test('getSpecialties should return List<SpecialtyModel>', () async {
      final tList = [
        {"id": 1, "name": "Cardio", "iconPath": "path"},
      ];
      when(
        () => mockApiClient.get('/specialties'),
      ).thenAnswer((_) async => tList);

      final result = await service.getSpecialties();

      expect(result, isA<List<SpecialtyModel>>());
      expect(result.first.name, 'Cardio');
    });

    test('getAllDoctors should return List<AdminDoctorModel>', () async {
      final tList = [
        {
          "id": 1,
          "fullName": "Dr. Test",
          "specialty": "Cardio",
          "email": "test@test.com",
          "phoneNumber": "123",
          "status": "Active",
          "imageUrl": "url",
        },
      ];
      when(() => mockApiClient.get('/doctors')).thenAnswer((_) async => tList);

      final result = await service.getAllDoctors();

      expect(result, isA<List<AdminDoctorModel>>());
    });

    test('API Error should throw ServerException', () async {
      when(() => mockApiClient.get(any())).thenThrow(Exception('Error'));

      expect(
        () => service.getDashboardStats(),
        throwsA(isA<service_lib.ServerException>()),
      );
    });
  });
}
