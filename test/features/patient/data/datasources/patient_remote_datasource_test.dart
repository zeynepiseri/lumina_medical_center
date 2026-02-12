import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/patient/data/datasources/patient_remote_datasource.dart';
import 'package:lumina_medical_center/features/patient/data/models/patient_model.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late PatientRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = PatientRemoteDataSourceImpl(mockApiClient);
  });

  group('PatientRemoteDataSource Tests', () {
    final tPatientJson = {
      "id": 1,
      "fullName": "Sarah User",
      "email": "test@test.com",
      "gender": "Female",
      "height": 165.0,
      "weight": 55.0,
      "bloodType": "A+",
      "allergies": ["Pollen"],
      "chronicDiseases": [],
    };

    test('getCurrentPatient should return PatientModel', () async {
      when(
        () => mockApiClient.get('/patients/me'),
      ).thenAnswer((_) async => tPatientJson);

      final result = await dataSource.getCurrentPatient();

      verify(() => mockApiClient.get('/patients/me')).called(1);
      expect(result, isA<PatientModel>());
      expect(result.fullName, 'Sarah User');
    });

    test('updateVitals should return void', () async {
      final tData = {"height": 170.0, "weight": 60.0};

      when(
        () => mockApiClient.patch('/patients/me/vitals', tData),
      ).thenAnswer((_) async => {});

      await dataSource.updateVitals(tData);

      verify(() => mockApiClient.patch('/patients/me/vitals', tData)).called(1);
    });
  });
}
