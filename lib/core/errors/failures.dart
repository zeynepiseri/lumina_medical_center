import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? debugMessage;

  const Failure({this.debugMessage});

  String get errorMessage => debugMessage ?? 'An unexpected error occurred';

  @override
  List<Object?> get props => [debugMessage];
}

class ServerFailure extends Failure {
  final String? errorCode;
  const ServerFailure({this.errorCode, super.debugMessage});

  @override
  List<Object?> get props => [errorCode, debugMessage];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.debugMessage});
}

class AuthFailure extends Failure {
  const AuthFailure({super.debugMessage});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.debugMessage});
}
