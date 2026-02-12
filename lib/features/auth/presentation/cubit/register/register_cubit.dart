import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/register_usecase.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/register/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit({required RegisterUseCase registerUseCase})
    : _registerUseCase = registerUseCase,
      super(RegisterInitial());

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String nationalId,
    required String rawPhoneNumber,
    required String gender,
    required DateTime birthDate,
    required String chronicDiseasesText,
    required String allergiesText,
    required String medicationsText,
  }) async {
    emit(RegisterLoading());

    final params = RegisterParams(
      fullName: fullName,
      email: email,
      password: password,
      nationalId: nationalId,
      rawPhoneNumber: rawPhoneNumber,
      gender: gender,
      birthDate: birthDate,
      chronicDiseasesText: chronicDiseasesText,
      allergiesText: allergiesText,
      medicationsText: medicationsText,
    );

    final result = await _registerUseCase(params);

    result.fold(
      (failure) => emit(RegisterFailure(failure)),
      (_) => emit(RegisterSuccess()),
    );
  }
}
