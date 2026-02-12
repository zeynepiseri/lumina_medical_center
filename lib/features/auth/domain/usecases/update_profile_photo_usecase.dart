import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/auth/data/repositories/user_repository.dart';

class UpdateProfilePhotoUseCase {
  final UserRepository _repository;

  UpdateProfilePhotoUseCase(this._repository);

  Future<Either<Failure, bool>> call(String imageUrl) async {
    return await _repository.updateProfilePhoto(imageUrl);
  }
}
