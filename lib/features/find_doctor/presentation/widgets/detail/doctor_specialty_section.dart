import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/extensions/color_extensions.dart';

class DoctorSpecialtySection extends StatelessWidget {
  final String mainSpecialty;
  final List<String> subSpecialties;

  const DoctorSpecialtySection({
    super.key,
    required this.mainSpecialty,
    required this.subSpecialties,
  });

  @override
  Widget build(BuildContext context) {
    if (subSpecialties.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.specialtyLabel,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
        ),
        context.vSpaceM,
        Wrap(
          spacing: context.spacing.s,
          runSpacing: context.spacing.s,
          children: [
            _buildChip(context, mainSpecialty, isPrimary: true),
            ...subSpecialties
                .where((e) => int.tryParse(e) == null)
                .map((e) => _buildChip(context, e)),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(
    BuildContext context,
    String label, {
    bool isPrimary = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.m,
        vertical: context.spacing.s,
      ),
      decoration: BoxDecoration(
        color: isPrimary
            ? context.colors.primary
            : context.colors.surface.darken(0.05),
        borderRadius: BorderRadius.circular(context.radius.medium),
      ),
      child: Text(
        label,
        style: context.textTheme.bodyMedium?.copyWith(
          color: isPrimary ? context.colors.surface : context.colors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
