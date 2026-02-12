import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String role;
  const LoginSuccess(this.role);
  @override
  List<Object> get props => [role];
}

class LoginFailure extends LoginState {
  final Failure failure;

  const LoginFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
