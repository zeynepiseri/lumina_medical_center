import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';

class PatientContactCard extends StatelessWidget {
  final String email;
  final String? phone;

  const PatientContactCard({super.key, required this.email, this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.paddingAllM,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.radius.large),
        border: Border.all(color: AppColors.slateGray.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.contactInfo,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
            ),
          ),
          context.vSpaceM,
          _buildRow(context, Icons.email_outlined, context.loc.email, email),
          if (phone != null && phone!.isNotEmpty) ...[
            Divider(
              height: 20,
              color: AppColors.slateGray.withValues(alpha: 0.1),
            ),
            _buildRow(
              context,
              Icons.phone_outlined,
              context.loc.phoneNumber,
              phone!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, color: AppColors.slateGray, size: 20),
        context.hSpaceM,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.slateGray,
              ),
            ),
            Text(
              value,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
