import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/login_usecase.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit({required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    final result = await _loginUseCase(email, password);

    result.fold(
      (failure) => emit(LoginFailure(failure)),
      (role) => emit(LoginSuccess(role)),
    );
  }
}
