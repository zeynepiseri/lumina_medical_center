import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class AdminTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final int maxLines;
  final bool isNumber;
  final String? hint;
  final int? maxLength;
  final bool isRequired;

  const AdminTextField({
    super.key,
    required this.label,
    this.controller,
    this.onChanged,
    this.maxLines = 1,
    this.isNumber = false,
    this.hint,
    this.maxLength,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: AppColors.slateGray,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          TextFormField(
            controller: controller,
            onChanged: onChanged,
            maxLines: maxLines,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            maxLength: maxLength,
            style: context.textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.slateGray.withValues(alpha: 0.5),
                fontSize: 13.sp,
              ),
              filled: true,

              fillColor: AppColors.slateGray.withValues(alpha: 0.05),
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: context.radius.medium.radius,
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
            ),
            validator: (val) {
              if (!isRequired) return null;
              return (val == null || val.isEmpty)
                  ? context.loc.requiredField
                  : null;
            },
          ),
        ],
      ),
    );
  }
}
