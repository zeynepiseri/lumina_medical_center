import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';

class PatientMenuTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool isDestructive;

  const PatientMenuTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? context.colors.error
        : (iconColor ?? context.colors.primary);

    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.s),
      child: Material(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.radius.medium),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(context.radius.medium),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing.m,
              vertical: context.spacing.m,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.slateGray.withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(context.radius.medium),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.radius.small),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                context.hSpaceM,
                Expanded(
                  child: Text(
                    title,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDestructive
                          ? context.colors.error
                          : context.colors.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.slateGray.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
