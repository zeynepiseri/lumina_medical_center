import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class DoctorsPageHeader extends StatelessWidget {
  final String branchName;

  const DoctorsPageHeader({super.key, required this.branchName});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: context.paddingHorizontalM.copyWith(top: context.spacing.s),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: context.colors.primary,
                size: context.layout.iconMedium - 4,
              ),
              onPressed: () => context.pop(),
            ),
            Expanded(
              child: Text(
                branchName,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            SizedBox(width: context.spacing.xxl),
          ],
        ),
      ),
    );
  }
}
