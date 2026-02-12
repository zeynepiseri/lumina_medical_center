import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final Failure failure;
  const RegisterFailure(this.failure);
  @override
  List<Object> get props => [failure];
}
