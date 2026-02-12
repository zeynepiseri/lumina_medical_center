import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class ConsultationTypeSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelected;

  const ConsultationTypeSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = context.colors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.selectConsultationType,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: activeColor,
          ),
        ),
        context.vSpaceM,
        Row(
          children: [
            Expanded(
              child: _buildCard(
                context,
                0,
                context.loc.message,
                "\$10",
                Icons.chat_bubble,
                activeColor,
              ),
            ),
            context.hSpaceS,
            Expanded(
              child: _buildCard(
                context,
                1,
                context.loc.phoneCall,
                "\$20",
                Icons.phone,
                activeColor,
              ),
            ),
            context.hSpaceS,
            Expanded(
              child: _buildCard(
                context,
                2,
                context.loc.videoCall,
                "\$30",
                Icons.videocam,
                activeColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context,
    int index,
    String title,
    String price,
    IconData icon,
    Color activeColor,
  ) {
    final isSelected = selectedIndex == index;
    final unselectedIconColor = context.colors.secondary;
    final goldColor = context.colors.secondary;

    return GestureDetector(
      onTap: () => onSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: context.spacing.m.h,
          horizontal: context.spacing.xs.w,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(context.radius.large),
          border: Border.all(
            color: isSelected ? goldColor : AppColors.alto,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: goldColor.withValues(alpha: 0.15),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : unselectedIconColor,
              size: context.layout.iconLarge.sp,
            ),
            SizedBox(height: context.spacing.s.h + context.spacing.xs.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? activeColor : unselectedIconColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            context.vSpaceXS,
            Text(
              price,
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: activeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
