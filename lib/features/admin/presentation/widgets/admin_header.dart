import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class AdminHeader extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const AdminHeader({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (context.width < 1100)
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.white),
            onPressed: onMenuPressed,
          ),
        Text(
          context.loc.dashboardTitle,
          style: context.textTheme.headlineMedium?.copyWith(
            color: AppColors.midnightBlue,
            fontWeight: FontWeight.bold,
          ),
        ),

        const Spacer(),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: context.spacing.m.w),
            child: const SearchField(),
          ),
        ),
        const ProfileCard(),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: context.spacing.m.w),
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.m.w,
        vertical: context.spacing.s.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: context.radius.medium.radius,
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person,
            color: AppColors.white,
            size: context.layout.iconSmall,
          ),
          context.hSpaceS,
          Text(
            context.loc.adminRoleName,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.white,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.white,
            size: context.layout.iconSmall,
          ),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: context.textTheme.bodyMedium?.copyWith(color: AppColors.white),
      decoration: InputDecoration(
        hintText: context.loc.search,
        hintStyle: context.textTheme.bodyMedium?.copyWith(
          color: AppColors.white.withValues(alpha: 0.54),
        ),
        fillColor: AppColors.oldGold,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.spacing.m.w,
          vertical: 12.h,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: context.radius.medium.radius,
        ),
        suffixIcon: Container(
          margin: EdgeInsets.all(context.spacing.xs),
          padding: EdgeInsets.all(context.spacing.s),
          decoration: BoxDecoration(
            color: AppColors.oldGold,
            borderRadius: context.radius.medium.radius,
          ),
          child: Icon(
            Icons.search,
            color: AppColors.white,
            size: context.layout.iconSmall,
          ),
        ),
      ),
    );
  }
}
