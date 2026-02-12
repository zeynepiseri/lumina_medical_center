import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/find_doctor/presentation/widgets/detail/timeline_tile.dart';

class DoctorTimelineSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const DoctorTimelineSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
        ),
        context.vSpaceM,
        ...items
            .where((e) => int.tryParse(e) == null)
            .map((item) => TimelineTile(text: item)),
      ],
    );
  }
}
