import 'package:equatable/equatable.dart';

abstract class DoctorEvent extends Equatable {
  const DoctorEvent();

  @override
  List<Object?> get props => [];
}

class LoadDoctors extends DoctorEvent {
  final String? branchId;

  const LoadDoctors({this.branchId});

  @override
  List<Object?> get props => [branchId];
}

class FilterDoctors extends DoctorEvent {
  final String query;

  const FilterDoctors(this.query);

  @override
  List<Object> get props => [query];
}
