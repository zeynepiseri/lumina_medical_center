import 'package:flutter/material.dart';
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
        borderRadius: BorderRadius.circular(context.radius.large),
        boxShadow: [
          BoxShadow(
            color: AppColors.slateGray.withValues(alpha: 0.1),
            blurRadius: 10,
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
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 18,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: AppColors.slateGray.withValues(alpha: 0.2),
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildVitalItem(
                context,
                context.loc.heightLabel,
                "${patient.height ?? '-'} cm",
                Icons.height,
              ),
              _buildVitalItem(
                context,
                context.loc.weightLabel,
                "${patient.weight ?? '-'} kg",
                Icons.monitor_weight_outlined,
              ),
              _buildVitalItem(
                context,
                context.loc.bloodTypeLabel,
                patient.bloodType ?? '-',
                Icons.bloodtype,
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
        Icon(icon, color: color ?? AppColors.slateGray, size: 28),
        context.vSpaceXS,
        Text(
          value,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.slateGray,
          ),
        ),
      ],
    );
  }
}
