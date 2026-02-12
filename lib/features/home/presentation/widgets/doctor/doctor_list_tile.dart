import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/app_image.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/pages/doctor_detail_page.dart';

class DoctorListTile extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorListTile({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailPage(doctor: doctor),
          ),
        );
      },
      child: Container(
        padding: context.paddingAllM,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: context.radius.large.radius,
          boxShadow: [
            BoxShadow(
              color: AppColors.slateGray.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: context.radius.medium.radius,
              child: AppImage(
                url: doctor.imageUrl,
                width: 70.w,
                height: 70.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.fullName,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${doctor.title} - ${doctor.specialty}",
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.slateGray,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppColors.ratingStar,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        doctor.rating.toStringAsFixed(1),
                        style: context.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.onSurface,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "(${doctor.reviewCount})",
                        style: context.textTheme.labelSmall?.copyWith(
                          color: AppColors.slateGray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: AppColors.slateGray.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
