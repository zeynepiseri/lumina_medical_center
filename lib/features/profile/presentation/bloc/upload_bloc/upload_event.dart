part of 'upload_bloc.dart';

abstract class UploadEvent {}

class UploadProfileImageEvent extends UploadEvent {
  final File imageFile;

  UploadProfileImageEvent(this.imageFile);
}
