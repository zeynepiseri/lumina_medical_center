import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/features/patient/domain/entities/patient_entity.dart';

class PatientVitalsCard extends StatelessWidget {
  final PatientEntity patient;
  final VoidCallback onEditTap;

  const PatientVitalsCard({
    super.key,
    required this.patient,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.paddingAllM,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: context.radius.large.radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.slateGray.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.loc.vitalsTitle,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
              ),
              GestureDetector(
                onTap: onEditTap,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    size: 18.sp,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: AppColors.slateGray.withValues(alpha: 0.1),
            height: 24.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildVitalItem(
                context,
                context.loc.heightLabel,
                "${patient.height?.toStringAsFixed(0) ?? '-'} cm",
                Icons.height_rounded,
              ),
              _buildVitalItem(
                context,
                context.loc.weightLabel,
                "${patient.weight?.toStringAsFixed(1) ?? '-'} kg",
                Icons.monitor_weight_outlined,
              ),
              _buildVitalItem(
                context,
                context.loc.bloodTypeLabel,
                patient.bloodType ?? '-',
                Icons.bloodtype_rounded,
                color: context.colors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color ?? AppColors.slateGray, size: 26.sp),
        context.vSpaceXS,
        Text(
          value,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.onSurface,
          ),
        ),
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: AppColors.slateGray,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}
