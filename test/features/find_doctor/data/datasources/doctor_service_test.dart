import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/find_doctor/data/datasources/doctor_service.dart';
import 'package:lumina_medical_center/features/find_doctor/data/models/doctor_model.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late DoctorService service;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    service = DoctorService(mockApiClient);
  });

  group('DoctorService Tests', () {
    group('getDoctors', () {
      final tDoctorListJson = [
        {
          "id": 1,
          "fullName": "Dr. Test",
          "specialty": "Cardio",
          "imageUrl": "url",
          "title": "MD",
          "branchName": "Cardiology",
          "biography": "Bio",
          "rating": 4.5,
          "reviewCount": 10,
          "patientCount": 100,
          "experience": 5,
          "consultationFee": 200.0,
          "schedules": [],
        },
      ];

      test('Should call GET /doctors when no branchId is provided', () async {
        when(
          () => mockApiClient.get('/doctors'),
        ).thenAnswer((_) async => tDoctorListJson);

        final result = await service.getDoctors();

        verify(() => mockApiClient.get('/doctors')).called(1);
        expect(result, isA<List<DoctorModel>>());
        expect(result.first.fullName, 'Dr. Test');
      });

      test(
        'Should call GET /doctors?branchId=X when branchId is provided',
        () async {
          const tBranchId = '1';
          when(
            () => mockApiClient.get('/doctors?branchId=$tBranchId'),
          ).thenAnswer((_) async => tDoctorListJson);

          final result = await service.getDoctors(branchId: tBranchId);

          verify(
            () => mockApiClient.get('/doctors?branchId=$tBranchId'),
          ).called(1);
          expect(result, isA<List<DoctorModel>>());
        },
      );

      test('Should throw Exception when API fails', () async {
        when(() => mockApiClient.get(any())).thenThrow(Exception('API Error'));

        expect(() => service.getDoctors(), throwsA(isA<Exception>()));
      });
    });

    group('getDoctorById', () {
      final tDoctorJson = {
        "id": 1,
        "fullName": "Dr. Test",
        "specialty": "Cardio",
        "imageUrl": "url",
        "title": "MD",
        "branchName": "Cardiology",
        "biography": "Bio",
        "rating": 4.5,
        "reviewCount": 10,
        "patientCount": 100,
        "experience": 5,
        "consultationFee": 200.0,
        "schedules": [],
      };
      const tId = 1;

      test('Should call GET /doctors/{id} and return DoctorModel', () async {
        when(
          () => mockApiClient.get('/doctors/$tId'),
        ).thenAnswer((_) async => tDoctorJson);

        final result = await service.getDoctorById(tId);

        verify(() => mockApiClient.get('/doctors/$tId')).called(1);
        expect(result, isA<DoctorModel>());
        expect(result.id, 1);
      });

      test('Should throw Exception when API fails', () async {
        when(() => mockApiClient.get(any())).thenThrow(Exception('API Error'));

        expect(() => service.getDoctorById(tId), throwsA(isA<Exception>()));
      });
    });
  });
}
