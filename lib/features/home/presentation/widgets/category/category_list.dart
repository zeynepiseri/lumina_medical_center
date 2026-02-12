import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class CategoryList extends StatelessWidget {
  final List<String> categories;
  const CategoryList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            context.loc.selectBranch,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.midnightBlue,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 110.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            separatorBuilder: (context, index) => SizedBox(width: 20.w),
            itemBuilder: (context, index) {
              return _buildCategoryItem(context, categories[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(BuildContext context, String name) {
    return Column(
      children: [
        Container(
          height: 70.w,
          width: 70.w,
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            _getIcon(name),
            size: 32.sp,
            color: AppColors.midnightBlue,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.midnightBlue,
          ),
        ),
      ],
    );
  }

  IconData _getIcon(String name) {
    switch (name.toLowerCase()) {
      case 'teeth':
        return Icons.masks_outlined;
      case 'heart':
        return Icons.favorite_border;
      case 'eye':
        return Icons.visibility_outlined;
      default:
        return Icons.local_hospital_outlined;
    }
  }
}
