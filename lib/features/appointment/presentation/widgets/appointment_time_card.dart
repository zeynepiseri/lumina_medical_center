import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class AppointmentTimeCard extends StatelessWidget {
  final DateTime? date;

  const AppointmentTimeCard({super.key, this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoTile(
            context,
            icon: Icons.calendar_month_outlined,
            label: context.loc.date,
            value: date != null ? DateFormat('d MMM yyyy').format(date!) : "-",
            color: AppColors.midnightBlue,
            isDark: true,
          ),
        ),
        context.hSpaceM,
        Expanded(
          child: _buildInfoTile(
            context,
            icon: Icons.access_time_rounded,
            label: context.loc.time,
            value: date != null ? DateFormat('HH:mm').format(date!) : "-",
            color: AppColors.oldGold,
            isDark: false,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: context.spacing.l.h - 4.h,
        horizontal: context.spacing.m.w,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: context.radius.xl.radius - 4.radius,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: context.opacity.medium),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(context.spacing.s.w),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDark ? AppColors.white : AppColors.black,
              size: 20.sp,
            ),
          ),
          context.vSpaceM,
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.8)
                  : AppColors.black.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: context.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
