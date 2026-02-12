import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, bool>> updateProfilePhoto(String imageUrl);

  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  );
}
