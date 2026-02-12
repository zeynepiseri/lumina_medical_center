import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/appointment/data/datasources/appointment_service.dart';
import 'package:lumina_medical_center/features/appointment/data/models/appointment_model.dart';
import 'package:lumina_medical_center/features/appointment/data/repositories/appointment_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockAppointmentService extends Mock implements AppointmentService {}

void main() {
  late AppointmentRepositoryImpl repository;
  late MockAppointmentService mockAppointmentService;

  setUp(() {
    mockAppointmentService = MockAppointmentService();
    repository = AppointmentRepositoryImpl(mockAppointmentService);
  });

  group('AppointmentRepositoryImpl Tests', () {
    group('getMyAppointments', () {
      final tAppointmentModel = AppointmentModel(
        id: 1,
        patientName: 'Test Patient',
        patientId: 1,
        doctorName: 'Dr. Test',
        doctorTitle: 'Prof.',
        doctorSpecialty: 'Cardiology',
        doctorImageUrl: 'url',
        appointmentTime: '2025-10-10T10:00:00',
        status: 'Confirmed',
        appointmentType: 'Online',
        doctorId: 101,
        healthIssue: 'Checkup',
        isAvailable: false,
      );
      final tList = [tAppointmentModel];

      test('Should return Entity list if service is successful', () async {
        when(
          () => mockAppointmentService.getMyAppointments(),
        ).thenAnswer((_) async => tList);

        final result = await repository.getMyAppointments();

        expect(result.isRight(), true);
      });

      test('Should return Failure if service fails', () async {
        when(
          () => mockAppointmentService.getMyAppointments(),
        ).thenThrow(ServerException(message: 'Error'));

        final result = await repository.getMyAppointments();

        expect(
          result,
          equals(const Left(ServerFailure(debugMessage: 'Error'))),
        );
      });
    });

    group('cancelAppointment', () {
      const tId = 123;
      test('Should return Right(null) if service is successful', () async {
        when(
          () => mockAppointmentService.deleteAppointment(tId),
        ).thenAnswer((_) async => true);

        final result = await repository.cancelAppointment(tId);

        expect(result, equals(const Right(null)));
      });
    });

    group('rescheduleAppointment', () {
      const tId = 123;
      final tNewDate = DateTime(2025, 12, 25, 14, 30);

      test('Date should be sent in correct format', () async {
        when(
          () => mockAppointmentService.rescheduleAppointment(any(), any()),
        ).thenAnswer((_) async => true);

        await repository.rescheduleAppointment(tId, tNewDate);

        verify(
          () => mockAppointmentService.rescheduleAppointment(tId, tNewDate),
        ).called(1);
      });
    });

    group('createAppointment', () {
      const tDoctorId = 101;
      final tDate = DateTime(2026, 10, 10, 14, 30);
      const tType = 'Online';
      const tMethod = 'Video Call';

      test('Are parameters passed correctly when calling service?', () async {
        when(
          () => mockAppointmentService.createAppointment(
            any(),
            any(),
            any(),
            any(),
          ),
        ).thenAnswer((_) async => true);

        final result = await repository.createAppointment(
          doctorId: tDoctorId,
          appointmentTime: tDate,
          type: tType,
          consultationMethod: tMethod,
        );

        verify(
          () => mockAppointmentService.createAppointment(
            tDoctorId,
            tDate,
            tType,
            tMethod,
          ),
        ).called(1);

        expect(result, equals(const Right(true)));
      });

      test('Should return ServerFailure if service fails', () async {
        when(
          () => mockAppointmentService.createAppointment(
            any(),
            any(),
            any(),
            any(),
          ),
        ).thenThrow(ServerException(message: 'Slot full'));

        final result = await repository.createAppointment(
          doctorId: tDoctorId,
          appointmentTime: tDate,
          type: tType,
        );

        expect(
          result,
          equals(const Left(ServerFailure(debugMessage: 'Slot full'))),
        );
      });
    });

    group('getBookedSlots', () {
      const tDoctorId = 101;

      final tDateSlots = [
        DateTime(2026, 10, 10, 09, 00),
        DateTime(2026, 10, 10, 10, 00),
      ];

      test('DateTime list from service should return successfully', () async {
        when(
          () => mockAppointmentService.getBookedSlots(tDoctorId),
        ).thenAnswer((_) async => tDateSlots);

        final result = await repository.getBookedSlots(tDoctorId);

        expect(result.isRight(), true);
        result.fold((_) => fail('Error was not expected'), (slots) {
          expect(slots.length, 2);
          expect(slots.first, isA<DateTime>());
          expect(slots.first.year, 2026);
        });
      });

      test('Should return Failure if service fails', () async {
        when(
          () => mockAppointmentService.getBookedSlots(tDoctorId),
        ).thenThrow(ServerException(message: 'No data'));

        final result = await repository.getBookedSlots(tDoctorId);

        expect(
          result,
          equals(const Left(ServerFailure(debugMessage: 'No data'))),
        );
      });
    });
  });
}
