import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_stats_entity.dart';

class DashboardMetricsGrid extends StatelessWidget {
  final AdminStatsEntity stats;

  const DashboardMetricsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cardData = [
      {
        "title": context.loc.totalPatients,
        "count": stats.totalPatients,
        "color": AppColors.info,
        "icon": Icons.people_outline_rounded,
      },
      {
        "title": context.loc.totalDoctors,
        "count": stats.totalDoctors,
        "color": AppColors.chartOrange,
        "icon": Icons.medical_services_outlined,
      },
      {
        "title": context.loc.totalAppointments,
        "count": stats.totalAppointments,
        "color": AppColors.chartSoftBlue,
        "icon": Icons.calendar_today_rounded,
      },
      {
        "title": context.loc.earnings,
        "count": "\$${stats.monthlyEarnings.toInt()}",
        "color": AppColors.oldGold,
        "icon": Icons.attach_money_rounded,
      },
    ];

    final crossAxisCount = context.responsive(mobile: 2, tablet: 2, desktop: 4);
    final childAspectRatio = context.responsive(
      mobile: 1.1,
      tablet: 1.3,
      desktop: 1.4,
    );

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cardData.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: context.spacing.m.w,
        mainAxisSpacing: context.spacing.m.h,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => _FileInfoCard(info: cardData[index]),
    );
  }
}

class _FileInfoCard extends StatelessWidget {
  final Map<String, dynamic> info;

  const _FileInfoCard({required this.info});

  @override
  Widget build(BuildContext context) {
    final Color itemColor = info['color'] as Color;

    return Container(
      padding: context.paddingAllM,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: context.radius.medium.radius,
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.2),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(context.spacing.s.w),
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: itemColor.withValues(alpha: 0.1),
                  borderRadius: context.radius.small.radius,
                ),
                child: Icon(info['icon'], color: itemColor, size: 20.sp),
              ),
              Icon(
                Icons.more_vert_rounded,
                color: AppColors.white.withValues(alpha: 0.5),
                size: 18.sp,
              ),
            ],
          ),
          Text(
            info['title'].toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
              fontSize: context.isMobile ? 12.sp : 14.sp,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  "${info['count']}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: AppColors.white,
                    fontSize: context.isMobile ? 20.sp : 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 30.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: itemColor,
                  borderRadius: context.radius.circular.radius,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
