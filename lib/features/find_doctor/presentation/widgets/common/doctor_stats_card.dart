import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';

class DoctorStatsCard extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorStatsCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: context.spacing.m,
        horizontal: context.spacing.s,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.radius.large),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.05),
            blurRadius: context.radius.medium,
            offset: Offset(0, context.spacing.xs),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            Icons.people,
            "${_formatCount(doctor.patientCount)}+",
            context.loc.patientsCountLabel,
          ),
          _buildDivider(context),
          _buildStatItem(
            context,
            Icons.work,
            "${doctor.experience} ${context.loc.experienceLabel}",
            context.loc.experienceYears,
          ),
          _buildDivider(context),
          _buildStatItem(
            context,
            Icons.star,
            doctor.rating.toStringAsFixed(1),
            "${context.loc.rating} (${doctor.reviewCount})",
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Container(
          padding: context.paddingAllS,
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.info,
            size: context.layout.iconMedium,
          ),
        ),
        context.vSpaceS,
        Text(
          value,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: AppColors.slateGray,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) => Container(
    height: context.layout.buttonHeightSmall,
    width: 1,
    color: AppColors.alto,
  );

  String _formatCount(int count) {
    if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(1)}k";
    }
    return count.toString();
  }
}
