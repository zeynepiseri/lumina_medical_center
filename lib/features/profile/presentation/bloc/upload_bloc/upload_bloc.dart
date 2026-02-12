import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/profile/data/datasources/profile_file_service.dart';

import 'package:lumina_medical_center/features/auth/domain/usecases/update_profile_photo_usecase.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final ProfileFileService _fileService;

  final UpdateProfilePhotoUseCase _updateProfilePhotoUseCase;

  UploadBloc(this._fileService, this._updateProfilePhotoUseCase)
    : super(UploadInitial()) {
    on<UploadProfileImageEvent>(_onUploadProfileImage);
  }

  Future<void> _onUploadProfileImage(
    UploadProfileImageEvent event,
    Emitter<UploadState> emit,
  ) async {
    emit(UploadLoading());

    try {
      final downloadUrl = await _fileService.uploadProfileImage(
        event.imageFile,
      );

      if (downloadUrl != null) {
        try {
          final result = await _updateProfilePhotoUseCase(downloadUrl);

          result.fold(
            (failure) => emit(UploadFailure(failure.errorMessage)),
            (success) => emit(UploadSuccess(downloadUrl)),
          );
        } catch (e) {
          emit(UploadFailure("profileUpdateErrorGeneric"));
        }
      } else {
        emit(UploadFailure("imageUploadServiceError"));
      }
    } catch (e) {
      emit(UploadFailure(e.toString()));
    }
  }
}
