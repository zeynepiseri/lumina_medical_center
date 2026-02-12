import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/entities/my_profile_entity.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/usecases/get_my_profile_usecase.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/usecases/update_my_profile_usecase.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/profile/doctor_profile_edit_event.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/profile/doctor_profile_edit_state.dart';

class DoctorProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetMyProfileUseCase _getMyProfile;
  final UpdateMyProfileUseCase _updateProfile;

  MyProfileEntity? _lastLoadedProfile;

  DoctorProfileBloc({
    required GetMyProfileUseCase getMyProfile,
    required UpdateMyProfileUseCase updateProfile,
  }) : _getMyProfile = getMyProfile,
       _updateProfile = updateProfile,
       super(ProfileLoading()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await _getMyProfile();

    result.fold((failure) => emit(ProfileError(failure.errorMessage)), (
      profile,
    ) {
      _lastLoadedProfile = profile;
      emit(ProfileLoaded(profile));
    });
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (_lastLoadedProfile == null) return;

    emit(ProfileUpdating());

    final params = UpdateProfileParams(
      biography: event.biography,
      experience: event.experience,
      schedules: event.schedules,
      subSpecialties: event.subSpecialties,
      educations: event.educations,
      imageUrl: event.imageUrl,
    );

    final result = await _updateProfile(params);

    result.fold(
      (failure) {
        emit(ProfileError("Update failed: ${failure.errorMessage}"));

        emit(ProfileLoaded(_lastLoadedProfile!));
      },
      (_) {
        emit(ProfileUpdateSuccess());

        add(LoadProfileEvent());
      },
    );
  }
}
