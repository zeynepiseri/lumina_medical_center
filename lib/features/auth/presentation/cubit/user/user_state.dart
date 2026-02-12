import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/features/auth/domain/entities/user_entity.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserEntity user;

  final bool isPhotoUploading;

  const UserLoaded(this.user, {this.isPhotoUploading = false});

  UserLoaded copyWith({UserEntity? user, bool? isPhotoUploading}) {
    return UserLoaded(
      user ?? this.user,
      isPhotoUploading: isPhotoUploading ?? this.isPhotoUploading,
    );
  }

  @override
  List<Object?> get props => [user, isPhotoUploading];
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);
  @override
  List<Object?> get props => [message];
}
