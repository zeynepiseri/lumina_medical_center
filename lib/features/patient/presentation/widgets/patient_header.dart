import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/app_image.dart';
import 'package:lumina_medical_center/features/profile/presentation/bloc/upload_bloc/upload_bloc.dart';

class PatientHeader extends StatelessWidget {
  final String? imageUrl;
  final String fullName;

  const PatientHeader({
    super.key,
    required this.imageUrl,
    required this.fullName,
  });

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null && context.mounted) {
      context.read<UploadBloc>().add(
        UploadProfileImageEvent(File(pickedFile.path)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 120,
              height: 120,
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
                  width: 120,
                  height: 120,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _pickAndUploadImage(context),
              child: Container(
                padding: context.paddingAllS,
                decoration: BoxDecoration(
                  color: context.colors.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.colors.surface, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: context.colors.onPrimary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        context.vSpaceM,
        Text(
          fullName,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
