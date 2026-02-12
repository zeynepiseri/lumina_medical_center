import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/update_profile_photo_usecase.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserUseCase _getUserUseCase;
  final UpdateProfilePhotoUseCase _updateProfilePhotoUseCase;

  UserCubit({
    required GetUserUseCase getUserUseCase,
    required UpdateProfilePhotoUseCase updateProfilePhotoUseCase,
  }) : _getUserUseCase = getUserUseCase,
       _updateProfilePhotoUseCase = updateProfilePhotoUseCase,
       super(UserInitial());

  Future<void> loadUser() async {
    emit(UserLoading());
    final result = await _getUserUseCase();
    result.fold(
      (failure) => emit(UserError(failure.errorMessage)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> updateProfilePhoto(String imageUrl) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;

      emit(currentState.copyWith(isPhotoUploading: true));

      final result = await _updateProfilePhotoUseCase(imageUrl);

      result.fold(
        (failure) {
          emit(currentState.copyWith(isPhotoUploading: false));
        },
        (success) {
          loadUser();
        },
      );
    }
  }
}
