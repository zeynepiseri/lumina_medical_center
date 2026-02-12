import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/data/datasources/doctor_profile_service.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/data/models/my_profile_model.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late DoctorProfileService service;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    service = DoctorProfileService(mockApiClient);
  });

  group('DoctorProfileService Tests', () {
    const tUserId = 101;

    final tProfileJson = {
      "id": 1,
      "fullName": "Gregory House",
      "title": "MD",
      "branchName": "Internal",
      "biography": "Genius",
      "experience": 10,
      "diplomaNo": "12345",
      "imageUrl": "url",
      "patientCount": 1000,
      "schedules": [],
      "subSpecialties": ["Diagnostic"],
      "educations": ["Johns Hopkins"],
    };

    test('getMyProfile should return MyProfileModel on success', () async {
      when(
        () => mockApiClient.get('/doctors/$tUserId'),
      ).thenAnswer((_) async => tProfileJson);

      final result = await service.getMyProfile(tUserId);

      verify(() => mockApiClient.get('/doctors/$tUserId')).called(1);
      expect(result, isA<MyProfileModel>());

      expect(result.fullName, 'Gregory House');
    });

    test('updateProfile should call PUT with correct data', () async {
      when(() => mockApiClient.put(any(), any())).thenAnswer((_) async => {});

      await service.updateProfile(
        userId: tUserId,
        biography: "New Bio",
        experience: 11,
        schedules: [],
        subSpecialties: [],
        educations: [],
        imageUrl: "new_url",
      );

      verify(() => mockApiClient.put('/doctors/$tUserId', any())).called(1);
    });

    test('API error should throw Exception', () async {
      when(() => mockApiClient.get(any())).thenThrow(Exception('API Error'));

      expect(() => service.getMyProfile(tUserId), throwsA(isA<Exception>()));
    });
  });
}
