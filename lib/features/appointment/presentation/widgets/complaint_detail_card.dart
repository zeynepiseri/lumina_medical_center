import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class ComplaintDetailCard extends StatelessWidget {
  final String healthIssue;

  const ComplaintDetailCard({super.key, required this.healthIssue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.patientComplaintNotes,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(context.spacing.l.w - 4.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: context.radius.xl.radius - 4.radius,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.notes,
                    color: AppColors.slateGray.withValues(alpha: 0.5),
                    size: 20.sp,
                  ),
                  context.hSpaceS,
                  Text(
                    context.loc.details,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: AppColors.slateGray.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                healthIssue,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.black,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
