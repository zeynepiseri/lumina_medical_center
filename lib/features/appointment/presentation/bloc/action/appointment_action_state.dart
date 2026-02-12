import 'package:equatable/equatable.dart';

abstract class AppointmentActionState extends Equatable {
  const AppointmentActionState();
  @override
  List<Object?> get props => [];
}

class ActionInitial extends AppointmentActionState {}

class ActionLoading extends AppointmentActionState {}

class ActionSuccess extends AppointmentActionState {
  final String message;
  const ActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ActionError extends AppointmentActionState {
  final String error;
  const ActionError(this.error);
  @override
  List<Object?> get props => [error];
}
