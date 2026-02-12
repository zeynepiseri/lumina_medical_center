import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/admin/domain/usecases/get_dashboard_stats_usecase.dart';
import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardBloc
    extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final GetDashboardStatsUseCase _getDashboardStatsUseCase;

  AdminDashboardBloc(this._getDashboardStatsUseCase)
    : super(AdminDashboardInitial()) {
    on<LoadAdminDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadAdminDashboard event,
    Emitter<AdminDashboardState> emit,
  ) async {
    emit(AdminDashboardLoading());

    final result = await _getDashboardStatsUseCase();

    result.fold(
      (failure) => emit(AdminDashboardError(failure)),
      (stats) => emit(AdminDashboardLoaded(stats)),
    );
  }
}
