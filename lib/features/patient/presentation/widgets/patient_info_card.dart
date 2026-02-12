import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';

class PatientInfoCard extends StatelessWidget {
  final String title;
  final List<String> items;
  final IconData icon;
  final Color iconColor;

  const PatientInfoCard({
    super.key,
    required this.title,
    required this.items,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.paddingAllM,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.radius.large),
        border: Border.all(color: AppColors.slateGray.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(context.radius.medium),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          context.hSpaceM,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.onSurface,
                  ),
                ),
                context.vSpaceS,
                items.isEmpty
                    ? Text(
                        context.loc.noInfoAvailable,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.slateGray,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: items.map((item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.slateGray.withValues(
                                alpha: 0.05,
                              ),
                              borderRadius: BorderRadius.circular(
                                context.radius.small,
                              ),
                              border: Border.all(
                                color: AppColors.slateGray.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Text(
                              item,
                              style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
