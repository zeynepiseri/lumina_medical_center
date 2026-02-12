import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/auth/domain/repositories/auth_repository.dart';

class GetUserRoleUseCase {
  final AuthRepository _repository;

  GetUserRoleUseCase(this._repository);

  Future<Either<Failure, String?>> call() async {
    return await _repository.getUserRole();
  }
}
