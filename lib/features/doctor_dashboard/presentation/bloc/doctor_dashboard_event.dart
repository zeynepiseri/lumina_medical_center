import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class LoadAppointmentsByDate extends DashboardEvent {
  final DateTime date;
  final bool forceRefresh;
  const LoadAppointmentsByDate(this.date, {this.forceRefresh = false});

  @override
  List<Object?> get props => [date, forceRefresh];
}
