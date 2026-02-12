import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/app_image.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';

class DoctorListCard extends StatelessWidget {
  final DoctorEntity doctor;
  final String branchId;

  const DoctorListCard({
    super.key,
    required this.doctor,
    required this.branchId,
  });

  @override
  Widget build(BuildContext context) {
    final double imageSize = context.spacing.xxxl + context.spacing.m;

    return Container(
      margin: EdgeInsets.only(bottom: context.spacing.l),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.radius.xl),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.06),

            blurRadius: context.radius.xxl,

            offset: Offset(0, context.spacing.s),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(context.radius.xl),
          onTap: () => context.push('/doctor-detail', extra: doctor),
          child: Padding(
            padding: context.paddingAllM,
            child: Row(
              children: [
                Hero(
                  tag: 'doctor_img_${doctor.id}_branch_$branchId',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(context.radius.large),
                    child: AppImage(
                      url: doctor.imageUrl,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                context.hSpaceM,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${doctor.title} ${doctor.fullName}",
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.colors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      context.vSpaceXS,
                      Text(
                        doctor.specialty,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colors.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      context.vSpaceS,
                      _buildRatingRow(context),
                    ],
                  ),
                ),
                _buildArrowButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingRow(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star_rounded,
          color: AppColors.ratingStar,
          size: context.layout.iconSmall + 2,
        ),
        SizedBox(width: context.spacing.xs),
        Text(
          doctor.rating > 0 ? doctor.rating.toStringAsFixed(1) : context.loc.nA,
          style: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: context.colors.primary.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(width: context.spacing.s),
        Container(
          width: context.spacing.xs,
          height: context.spacing.xs,
          decoration: BoxDecoration(
            color: AppColors.slateGray.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: context.spacing.s),
        Text(
          "${doctor.patientCount} ${context.loc.patientsLabel}",
          style: context.textTheme.labelSmall?.copyWith(
            color: AppColors.slateGray,
          ),
        ),
      ],
    );
  }

  Widget _buildArrowButton(BuildContext context) {
    return Container(
      height: context.layout.buttonHeightSmall,
      width: context.layout.buttonHeightSmall,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(context.radius.large),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.4),
            blurRadius: context.radius.medium,
            offset: Offset(0, context.spacing.xs),
          ),
        ],
      ),
      child: Icon(
        Icons.arrow_forward_rounded,
        color: context.colors.surface,
        size: context.layout.iconSmall + 4,
      ),
    );
  }
}
