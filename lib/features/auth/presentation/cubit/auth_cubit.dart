import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/get_user_role_usecase.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/logout_usecase.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String role;
  const Authenticated(this.role);
  @override
  List<Object?> get props => [role];
}

class Unauthenticated extends AuthState {}

class AuthCubit extends Cubit<AuthState> {
  final GetUserRoleUseCase _getUserRoleUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthCubit({
    required GetUserRoleUseCase getUserRoleUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _getUserRoleUseCase = getUserRoleUseCase,
       _logoutUseCase = logoutUseCase,
       super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    final result = await _getUserRoleUseCase();

    result.fold((failure) => emit(Unauthenticated()), (role) {
      if (role != null && role.isNotEmpty) {
        emit(Authenticated(role));
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await _logoutUseCase();
    emit(Unauthenticated());
  }

  void loggedIn(String role) {
    emit(Authenticated(role));
  }
}
