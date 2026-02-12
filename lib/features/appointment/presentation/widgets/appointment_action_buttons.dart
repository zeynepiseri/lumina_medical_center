import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class AppointmentActionButtons extends StatelessWidget {
  final bool isOnline;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;
  final VoidCallback onVideoCall;

  const AppointmentActionButtons({
    super.key,
    required this.isOnline,
    required this.onCancel,
    required this.onReschedule,
    required this.onVideoCall,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.colors.primary;

    return Column(
      children: [
        if (isOnline) ...[
          SizedBox(
            width: double.infinity,
            height: context.layout.buttonHeight.h,
            child: ElevatedButton.icon(
              onPressed: onVideoCall,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: context.radius.large.radius,
                ),
              ),
              icon: const Icon(Icons.video_call),
              label: Text(
                context.loc.startVideoCall,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          context.vSpaceM,
        ],
        SizedBox(
          width: double.infinity,
          height: context.layout.buttonHeight.h,
          child: OutlinedButton.icon(
            onPressed: onReschedule,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: context.radius.large.radius,
              ),
            ),
            icon: Icon(Icons.edit_calendar, color: primaryColor),
            label: Text(
              context.loc.rescheduleAppointment,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
        ),
        context.vSpaceM,
        SizedBox(
          width: double.infinity,
          height: context.layout.buttonHeight.h,
          child: TextButton.icon(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
              backgroundColor: AppColors.error.withValues(
                alpha: context.opacity.faint,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: context.radius.large.radius,
              ),
            ),
            icon: const Icon(Icons.cancel_outlined),
            label: Text(
              context.loc.cancelAppointment,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
