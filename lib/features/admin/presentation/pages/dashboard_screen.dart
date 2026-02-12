import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_dashboard_bloc.dart';

import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_dashboard_event.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_dashboard_state.dart';

import 'package:lumina_medical_center/features/admin/presentation/widgets/admin_dashboard/admin_dashboard_metrics_grid.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/admin_dashboard/admin_storage_details_card.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/admin_dashboard/top_doctors_table.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/admin_header.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const DashboardScreen({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.width >= 1100;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: context.pagePadding,
          child: Column(
            children: [
              AdminHeader(onMenuPressed: onMenuPressed),
              context.vSpaceL,
              BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
                builder: (context, state) {
                  if (state is AdminDashboardLoading) {
                    return SizedBox(
                      height: 400.h,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is AdminDashboardLoaded) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              DashboardMetricsGrid(stats: state.stats),
                              TopDoctorsTable(doctors: state.stats.topDoctors),
                              if (!isDesktop) ...[
                                context.vSpaceL,
                                StorageDetailsCard(stats: state.stats),
                              ],
                            ],
                          ),
                        ),
                        if (isDesktop) context.hSpaceL,

                        if (isDesktop)
                          Expanded(
                            flex: 2,
                            child: StorageDetailsCard(stats: state.stats),
                          ),
                      ],
                    );
                  } else if (state is AdminDashboardError) {
                    return Center(
                      child: Text(
                        "${context.loc.error}: ${state.failure.errorMessage}",
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
