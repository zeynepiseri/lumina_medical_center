part of 'upload_bloc.dart';

abstract class UploadState {}

class UploadInitial extends UploadState {}

class UploadLoading extends UploadState {}

class UploadSuccess extends UploadState {
  final String response;
  UploadSuccess(this.response);
}

class UploadFailure extends UploadState {
  final String errorMessage;
  UploadFailure(this.errorMessage);
}
