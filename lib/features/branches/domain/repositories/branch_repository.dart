import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import '../entities/branch_entity.dart';

class CreateBranchParams {
  final String name;
  final String imageUrl;

  CreateBranchParams({required this.name, required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {"name": name, "imageUrl": imageUrl};
  }
}

abstract class BranchRepository {
  Future<Either<Failure, List<BranchEntity>>> getAllBranches();
  Future<Either<Failure, BranchEntity>> createBranch(CreateBranchParams params);
}
