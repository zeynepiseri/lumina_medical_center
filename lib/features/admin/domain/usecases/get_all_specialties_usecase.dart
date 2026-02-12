import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import '../repositories/admin_repository.dart';
import '../entities/specialty_entity.dart';

class GetAllSpecialtiesUseCase {
  final AdminRepository _repository;

  GetAllSpecialtiesUseCase(this._repository);

  Future<Either<Failure, List<SpecialtyEntity>>> call() async {
    return await _repository.getSpecialties();
  }
}
