import 'package:dartz/dartz.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import '../entities/admin_stats_entity.dart';
import '../repositories/admin_repository.dart';

class GetDashboardStatsUseCase {
  final AdminRepository _repository;

  GetDashboardStatsUseCase(this._repository);

  Future<Either<Failure, AdminStatsEntity>> call() async {
    return await _repository.getDashboardStats();
  }
}
