import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SectionHeader({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            context.loc.seeAll,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.slateGray,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
