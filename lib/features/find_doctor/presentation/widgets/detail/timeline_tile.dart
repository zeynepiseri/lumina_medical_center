import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class TimelineTile extends StatelessWidget {
  final String text;

  const TimelineTile({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final double dotSize = context.spacing.s + 4;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: context.spacing.xs),
              child: Container(
                height: dotSize,
                width: dotSize,
                decoration: BoxDecoration(
                  color: context.colors.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.colors.surface, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.secondary.withValues(alpha: 0.3),
                      blurRadius: context.radius.small,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 2,
              height: context.layout.buttonHeightSmall,
              color: context.colors.onSurface.withValues(alpha: 0.15),
            ),
          ],
        ),
        context.hSpaceM,
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: context.spacing.l),
            child: Text(
              text,
              style: context.textTheme.bodyLarge?.copyWith(height: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
