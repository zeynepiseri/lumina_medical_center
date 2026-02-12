import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/expandable_text.dart';

class DoctorAboutSection extends StatelessWidget {
  final String biography;

  const DoctorAboutSection({super.key, required this.biography});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.aboutDoctor,
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
        ),
        context.vSpaceS,
        ExpandableText(
          text: biography,
          maxLines: 3,
          linkColor: context.colors.secondary,
        ),
      ],
    );
  }
}
