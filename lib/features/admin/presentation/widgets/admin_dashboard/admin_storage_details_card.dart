import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_stats_entity.dart';

class StorageDetailsCard extends StatelessWidget {
  final AdminStatsEntity stats;

  const StorageDetailsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.paddingAllM,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: context.radius.medium.radius,
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(
              alpha: context.opacity.faint,
            ),
            blurRadius: 20.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.statsDetailTitle,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
          context.vSpaceL,
          SizedBox(
            height: 200.h,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 70.r,
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(
                        color: AppColors.oldGold,
                        value: 25,
                        showTitle: false,
                        radius: 22.r,
                      ),
                      PieChartSectionData(
                        color: AppColors.chartBlue,
                        value: 20,
                        showTitle: false,
                        radius: 19.r,
                      ),
                      PieChartSectionData(
                        color: AppColors.chartYellow,
                        value: 10,
                        showTitle: false,
                        radius: 16.r,
                      ),
                      PieChartSectionData(
                        color: AppColors.chartRed,
                        value: 15,
                        showTitle: false,
                        radius: 13.r,
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stats.totalPatients.toString(),
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                          fontSize: 24.sp,
                          height: 0.5,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        context.loc.patientsLabel,
                        style: context.textTheme.labelMedium?.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          context.vSpaceL,
          _storageInfoCard(
            context,
            title: context.loc.totalAppointments,
            amount: "${stats.totalAppointments}",
            icon: Icons.calendar_today_rounded,
            color: AppColors.info,
          ),
          _storageInfoCard(
            context,
            title: context.loc.totalDoctors,
            amount: "${stats.totalDoctors}",
            icon: Icons.person_rounded,
            color: AppColors.chartOrange,
          ),
          _storageInfoCard(
            context,
            title: context.loc.earnings,
            amount: "\$${stats.monthlyEarnings.toInt()}",
            icon: Icons.attach_money_rounded,
            color: AppColors.chartBlue,
          ),
        ],
      ),
    );
  }

  Widget _storageInfoCard(
    BuildContext context, {
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(top: context.spacing.m.h),
      padding: context.paddingAllM,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.w,
          color: AppColors.alto.withValues(alpha: 0.5),
        ),
        borderRadius: context.radius.medium.radius,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.sp),
          context.hSpaceM,
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
            ),
          ),
          Text(
            amount,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
