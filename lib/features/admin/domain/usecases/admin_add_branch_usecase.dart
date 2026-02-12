import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/branches/domain/repositories/branch_repository.dart';

class AdminAddBranchUseCase {
  final BranchRepository _repository;

  AdminAddBranchUseCase(this._repository);

  Future<Either<Failure, BranchEntity>> call({
    required String name,
    required String imageUrl,
  }) async {
    return await _repository.createBranch(
      CreateBranchParams(name: name, imageUrl: imageUrl),
    );
  }
}
