import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class PatientInfoCard extends StatelessWidget {
  final String name;
  final String type;
  final bool isOnline;

  const PatientInfoCard({
    super.key,
    required this.name,
    required this.type,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.midnightBlue;
    final accentColor = AppColors.oldGold;

    return Container(
      padding: EdgeInsets.all(context.spacing.l.w - 4.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: context.radius.xl.radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 60.w,
            width: 60.w,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : "?",
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ),
          context.hSpaceM,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isOnline
                        ? AppColors.success.withValues(alpha: 0.1)
                        : accentColor.withValues(alpha: 0.15),
                    borderRadius: context.radius.medium.radius,
                  ),
                  child: Text(
                    type,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isOnline ? AppColors.success : primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.alto.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.message_outlined,
              color: primaryColor,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
