import 'package:equatable/equatable.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_stats_entity.dart';

abstract class AdminDashboardState extends Equatable {
  const AdminDashboardState();

  @override
  List<Object> get props => [];
}

class AdminDashboardInitial extends AdminDashboardState {}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardLoaded extends AdminDashboardState {
  final AdminStatsEntity stats;

  const AdminDashboardLoaded(this.stats);

  @override
  List<Object> get props => [stats];
}

class AdminDashboardError extends AdminDashboardState {
  final Failure failure;

  const AdminDashboardError(this.failure);

  @override
  List<Object> get props => [failure];
}
