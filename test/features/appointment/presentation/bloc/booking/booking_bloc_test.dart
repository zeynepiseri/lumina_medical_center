import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/create_appointment_usecase.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/get_booked_slots_usecase.dart';
import 'package:lumina_medical_center/features/appointment/domain/usecases/update_appointment_usecase.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/booking/booking_bloc.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBookedSlotsUseCase extends Mock implements GetBookedSlotsUseCase {}

class MockCreateAppointmentUseCase extends Mock
    implements CreateAppointmentUseCase {}

class MockUpdateAppointmentUseCase extends Mock
    implements UpdateAppointmentUseCase {}

void main() {
  late BookingBloc bookingBloc;
  late MockGetBookedSlotsUseCase mockGetBookedSlotsUseCase;
  late MockCreateAppointmentUseCase mockCreateAppointmentUseCase;
  late MockUpdateAppointmentUseCase mockUpdateAppointmentUseCase;

  setUp(() {
    mockGetBookedSlotsUseCase = MockGetBookedSlotsUseCase();
    mockCreateAppointmentUseCase = MockCreateAppointmentUseCase();
    mockUpdateAppointmentUseCase = MockUpdateAppointmentUseCase();

    bookingBloc = BookingBloc(
      getBookedSlotsUseCase: mockGetBookedSlotsUseCase,
      createAppointmentUseCase: mockCreateAppointmentUseCase,
      updateAppointmentUseCase: mockUpdateAppointmentUseCase,
    );
  });

  tearDown(() {
    bookingBloc.close();
  });

  final tDate = DateTime.now();
  const tDoctorId = 1;
  const tDoctor = DoctorEntity(
    id: 1,
    fullName: 'Dr. House',
    specialty: 'Diagnostic',
    imageUrl: 'url',
    title: 'MD',
    branchName: 'Internal',
    rating: 4.8,
    patientCount: 100,
  );

  group('BookingBloc Tests', () {
    test('Initial state should be BookingState with status initial', () {
      expect(bookingBloc.state.status, equals(BookingStatus.initial));
    });

    blocTest<BookingBloc, BookingState>(
      'Slots should be loaded when LoadBookingSlots is triggered [loading, loaded]',
      build: () {
        when(
          () => mockGetBookedSlotsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));
        return bookingBloc;
      },
      act: (bloc) => bloc.add(const LoadBookingSlots(doctorId: tDoctorId)),
      expect: () => [
        const BookingState(status: BookingStatus.loading),
        isA<BookingState>()
            .having((s) => s.status, 'status', BookingStatus.loaded)
            .having((s) => s.bookedSlots, 'bookedSlots', isEmpty)
            .having((s) => s.next14Days.length, 'next14Days', 14),
      ],
    );

    blocTest<BookingBloc, BookingState>(
      'selectedDateIndex should be updated when SelectDate is triggered',
      build: () => bookingBloc,
      seed: () =>
          BookingState(status: BookingStatus.loaded, next14Days: [tDate]),
      act: (bloc) => bloc.add(SelectDate(tDate)),
      expect: () => [
        isA<BookingState>()
            .having((s) => s.selectedDateIndex, 'index', 0)
            .having((s) => s.selectedTime, 'time', isNull),
      ],
    );

    blocTest<BookingBloc, BookingState>(
      'selectedTime should be updated when SelectTime is triggered',
      build: () => bookingBloc,
      act: (bloc) => bloc.add(const SelectTime('10:00')),
      expect: () => [
        isA<BookingState>().having((s) => s.selectedTime, 'time', '10:00'),
      ],
    );

    blocTest<BookingBloc, BookingState>(
      'Should emit [submitting, success] if ConfirmBooking is successful',
      build: () {
        when(
          () => mockCreateAppointmentUseCase(
            doctorId: any(named: 'doctorId'),
            appointmentTime: any(named: 'appointmentTime'),
            type: any(named: 'type'),
            consultationMethod: any(named: 'consultationMethod'),
          ),
        ).thenAnswer((_) async => const Right(true));
        return bookingBloc;
      },

      seed: () => BookingState(
        status: BookingStatus.loaded,
        next14Days: [tDate],
        selectedDateIndex: 0,
        selectedTime: '10:00',
        selectedTabIndex: 0,
      ),
      act: (bloc) => bloc.add(const ConfirmBooking(doctor: tDoctor)),
      expect: () => [
        isA<BookingState>().having(
          (s) => s.status,
          'status',
          BookingStatus.submitting,
        ),
        isA<BookingState>().having(
          (s) => s.status,
          'status',
          BookingStatus.success,
        ),
      ],
    );

    blocTest<BookingBloc, BookingState>(
      'Should emit [submitting, failure, loaded] if ConfirmBooking fails',
      build: () {
        when(
          () => mockCreateAppointmentUseCase(
            doctorId: any(named: 'doctorId'),
            appointmentTime: any(named: 'appointmentTime'),
            type: any(named: 'type'),
            consultationMethod: any(named: 'consultationMethod'),
          ),
        ).thenAnswer(
          (_) async => const Left(ServerFailure(debugMessage: 'Error')),
        );
        return bookingBloc;
      },
      seed: () => BookingState(
        status: BookingStatus.loaded,
        next14Days: [tDate],
        selectedDateIndex: 0,
        selectedTime: '10:00',
      ),
      act: (bloc) => bloc.add(const ConfirmBooking(doctor: tDoctor)),
      expect: () => [
        isA<BookingState>().having(
          (s) => s.status,
          'status',
          BookingStatus.submitting,
        ),
        isA<BookingState>()
            .having((s) => s.status, 'status', BookingStatus.failure)
            .having((s) => s.errorMessage, 'error', 'Error'),
        isA<BookingState>().having(
          (s) => s.status,
          'status',
          BookingStatus.loaded,
        ),
      ],
    );
  });
}
