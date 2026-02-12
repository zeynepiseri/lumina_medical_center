import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/auth/data/repositories/user_repository.dart';

class ChangePasswordUseCase {
  final UserRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<Either<Failure, void>> call(
    String currentPassword,
    String newPassword,
  ) async {
    return await _repository.changePassword(currentPassword, newPassword);
  }
}
