import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/app_image.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String userImage;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colors.surface,
            border: Border.all(color: context.colors.secondary, width: 3),
          ),
          child: ClipOval(
            child: AppImage(url: userImage, fit: BoxFit.cover),
          ),
        ),
        context.hSpaceM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.loc.hello,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colors.onSurface.withValues(alpha: 0.6),
                  fontSize: 16,
                ),
              ),
              Text(
                userName,
                style: context.textTheme.headlineMedium?.copyWith(
                  height: 1.1,
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
