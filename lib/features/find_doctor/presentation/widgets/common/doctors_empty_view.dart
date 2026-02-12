import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class DoctorsEmptyView extends StatelessWidget {
  const DoctorsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: context.spacing.xxxl,
            color: AppColors.slateGray,
          ),
          context.vSpaceL,
          Text(
            context.loc.noSpecialistsFound,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
            ),
          ),
          context.vSpaceS,
          Text(
            context.loc.noDoctorsInBranch,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.slateGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
