import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/app_image.dart';

class PatientHeader extends StatelessWidget {
  final String? imageUrl;
  final String fullName;
  final VoidCallback onEditPhotoTap;

  const PatientHeader({
    super.key,
    required this.imageUrl,
    required this.fullName,
    required this.onEditPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.surface, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipOval(
                child: AppImage(
                  url: imageUrl ?? '',
                  fit: BoxFit.cover,
                  width: 110,
                  height: 110,
                ),
              ),
            ),
            GestureDetector(
              onTap: onEditPhotoTap,
              child: Container(
                padding: context.paddingAllS,
                decoration: BoxDecoration(
                  color: context.colors.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.colors.surface, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: context.colors.surface,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        context.vSpaceM,
        Text(
          fullName,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
