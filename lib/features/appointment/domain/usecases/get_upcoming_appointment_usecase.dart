import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';
import 'package:lumina_medical_center/features/appointment/domain/repositories/appointment_repository.dart';

class GetUpcomingAppointmentUseCase {
  final AppointmentRepository repository;

  GetUpcomingAppointmentUseCase(this.repository);

  Future<Either<Failure, AppointmentEntity?>> call() async {
    final result = await repository.getMyAppointments();

    return result.map((appointments) {
      final now = DateTime.now();

      final futureApps = appointments.where((a) {
        if (a.status.toLowerCase() == 'cancelled') return false;
        final date = DateTime.tryParse(a.appointmentTime);
        return date != null && date.isAfter(now);
      }).toList();

      futureApps.sort((a, b) {
        final dateA = DateTime.tryParse(a.appointmentTime) ?? DateTime(2099);
        final dateB = DateTime.tryParse(b.appointmentTime) ?? DateTime(2099);
        return dateA.compareTo(dateB);
      });

      return futureApps.isNotEmpty ? futureApps.first : null;
    });
  }
}
