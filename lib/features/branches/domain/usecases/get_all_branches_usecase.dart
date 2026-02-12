import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/branches/domain/repositories/branch_repository.dart';

class GetAllBranchesUseCase {
  final BranchRepository _repository;

  GetAllBranchesUseCase(this._repository);

  Future<Either<Failure, List<BranchEntity>>> call() async {
    return await _repository.getAllBranches();
  }
}
