import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class BookingTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const BookingTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = context.colors.primary;

    return Container(
      padding: EdgeInsets.all(context.spacing.xs.w),
      decoration: BoxDecoration(
        color: context.colors.surface == AppColors.white
            ? AppColors.alto.withValues(alpha: 0.3)
            : AppColors.black,
        borderRadius: BorderRadius.circular(context.radius.xl),
      ),
      child: Row(
        children: [
          _buildTabItem(context, context.loc.inPerson, 0, activeColor),
          _buildTabItem(context, context.loc.online, 1, activeColor),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    String title,
    int index,
    Color activeColor,
  ) {
    final isSelected = index == selectedIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: context.spacing.s.h + 4.h),
          decoration: BoxDecoration(
            color: isSelected ? context.colors.surface : AppColors.transparent,
            borderRadius: BorderRadius.circular(context.radius.large),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.05),
                      blurRadius: 5,
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: context.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isSelected ? activeColor : context.colors.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
