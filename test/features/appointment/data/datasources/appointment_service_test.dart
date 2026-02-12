import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/appointment/data/datasources/appointment_service.dart';
import 'package:lumina_medical_center/features/appointment/data/models/appointment_model.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late AppointmentService service;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    service = AppointmentService(mockApiClient);
  });

  group('AppointmentService Tests', () {
    final tAppointmentJson = {
      "id": 1,
      "patientId": 101,
      "doctorId": 202,
      "doctorName": "Dr. House",
      "doctorTitle": "MD",
      "doctorSpecialty": "Diagnostic",
      "doctorImageUrl": "url",
      "appointmentTime": "2023-10-10T10:00:00",
      "status": "SCHEDULED",
      "appointmentType": "Online",
      "patientName": "John Doe",
      "healthIssue": "Headache",
      "isAvailable": false,
    };

    test('getMyAppointments should return List<AppointmentModel>', () async {
      when(
        () => mockApiClient.get('/appointments/my'),
      ).thenAnswer((_) async => [tAppointmentJson]);

      final result = await service.getMyAppointments();

      verify(() => mockApiClient.get('/appointments/my')).called(1);
      expect(result, isA<List<AppointmentModel>>());
      expect(result.first.doctorName, 'Dr. House');
    });

    test('createAppointment should return true on success', () async {
      const tDoctorId = 202;
      final tTime = DateTime(2023, 10, 10, 10, 0);
      const tType = "Online";
      const tMethod = "Video";

      when(() => mockApiClient.post('/appointments', any())).thenAnswer(
        (_) async =>
            Response(requestOptions: RequestOptions(path: ''), statusCode: 201),
      );

      final result = await service.createAppointment(
        tDoctorId,
        tTime,
        tType,
        tMethod,
      );

      verify(() => mockApiClient.post('/appointments', any())).called(1);
      expect(result, true);
    });

    test('deleteAppointment should return true on success', () async {
      const tId = 1;
      when(() => mockApiClient.delete('/appointments/$tId')).thenAnswer(
        (_) async =>
            Response(requestOptions: RequestOptions(path: ''), statusCode: 200),
      );

      final result = await service.deleteAppointment(tId);

      verify(() => mockApiClient.delete('/appointments/$tId')).called(1);
      expect(result, true);
    });

    test('updateAppointment should call PUT and return true', () async {
      const tId = 1;
      final tTime = DateTime(2023, 10, 11, 10, 0);
      const tType = "In-Person";

      when(() => mockApiClient.put('/appointments/$tId', any())).thenAnswer(
        (_) async =>
            Response(requestOptions: RequestOptions(path: ''), statusCode: 200),
      );

      final result = await service.updateAppointment(tId, tTime, tType, null);

      verify(() => mockApiClient.put('/appointments/$tId', any())).called(1);
      expect(result, true);
    });
  });
}
