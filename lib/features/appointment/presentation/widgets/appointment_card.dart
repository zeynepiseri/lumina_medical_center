import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/app_image.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';

class AppointmentCard extends StatefulWidget {
  final AppointmentEntity appointment;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;
  final bool isLoading;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onCancel,
    this.onReschedule,
    this.isLoading = false,
  });

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final date =
        DateTime.tryParse(widget.appointment.appointmentTime) ?? DateTime.now();
    final formattedDate = DateFormat('dd MMM').format(date);
    final formattedTime = DateFormat('HH:mm').format(date);

    final isUpcoming =
        widget.appointment.status.toLowerCase() == 'upcoming' ||
        widget.appointment.status.toLowerCase() == 'confirmed';
    final isCancelled = widget.appointment.status.toLowerCase() == 'cancelled';
    final isActive = isUpcoming && !isCancelled;
    final isOnline = widget.appointment.appointmentType.toLowerCase().contains(
      'online',
    );

    return IgnorePointer(
      ignoring: !isActive && !_isExpanded,
      child: Opacity(
        opacity: isActive ? 1.0 : 0.6,
        child: AnimatedContainer(
          duration: 300.ms,
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: context.radius.large.radius,
            border: _isExpanded
                ? Border.all(
                    color: AppColors.midnightBlue.withValues(alpha: 0.3),
                  )
                : Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: context.radius.large.radius,
              child: Padding(
                padding: context.paddingAllM,
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildCompactAvatar(),
                        context.hSpaceM,

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.appointment.doctorName,
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.midnightBlue,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                widget.appointment.doctorSpecialty,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: AppColors.reefGold,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 12.sp,
                                  color: AppColors.slateGray,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  formattedDate,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.slateGray,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 12.sp,
                                  color: AppColors.slateGray,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  formattedTime,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.slateGray,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    AnimatedSize(
                      duration: 300.ms,
                      curve: Curves.easeInOut,
                      alignment: Alignment.topCenter,
                      child: _isExpanded
                          ? Column(
                              children: [
                                context.vSpaceM,
                                Divider(
                                  height: 1,
                                  color: AppColors.slateGray.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                                context.vSpaceM,

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildTypeBadge(context, isOnline),
                                    _buildStatusBadge(
                                      context,
                                      isUpcoming,
                                      isCancelled,
                                    ),
                                  ],
                                ),

                                if (isActive) ...[
                                  context.vSpaceL,
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 40.h,
                                          child: OutlinedButton(
                                            onPressed: widget.onCancel,
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: AppColors.error,
                                              side: const BorderSide(
                                                color: AppColors.error,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: context
                                                    .radius
                                                    .medium
                                                    .radius,
                                              ),
                                            ),
                                            child: Text(context.loc.cancel),
                                          ),
                                        ),
                                      ),
                                      context.hSpaceM,
                                      Expanded(
                                        child: SizedBox(
                                          height: 40.h,
                                          child: ElevatedButton(
                                            onPressed: widget.isLoading
                                                ? null
                                                : widget.onReschedule,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.midnightBlue,
                                              foregroundColor: AppColors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: context
                                                    .radius
                                                    .medium
                                                    .radius,
                                              ),
                                            ),
                                            child: widget.isLoading
                                                ? SizedBox(
                                                    width: 16.w,
                                                    height: 16.w,
                                                    child:
                                                        const CircularProgressIndicator(
                                                          color:
                                                              AppColors.white,
                                                          strokeWidth: 2,
                                                        ),
                                                  )
                                                : Text(context.loc.reschedule),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    if (!_isExpanded)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.slateGray.withValues(alpha: 0.5),
                          size: 20.sp,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactAvatar() {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: AppColors.slateGray.withValues(alpha: 0.1),
        borderRadius: context.radius.medium.radius,
      ),
      clipBehavior: Clip.antiAlias,
      child: widget.appointment.doctorImageUrl.isNotEmpty
          ? AppImage(url: widget.appointment.doctorImageUrl, fit: BoxFit.cover)
          : Center(
              child: Text(
                widget.appointment.doctorName.isNotEmpty
                    ? widget.appointment.doctorName[0]
                    : "D",
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.slateGray,
                ),
              ),
            ),
    );
  }

  Widget _buildTypeBadge(BuildContext context, bool isOnline) {
    final color = isOnline ? AppColors.info : AppColors.slateGray;
    final bgColor = isOnline
        ? AppColors.info.withValues(alpha: 0.1)
        : AppColors.slateGray.withValues(alpha: 0.1);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: context.radius.medium.radius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline
                ? Icons.phone_in_talk_outlined
                : Icons.location_on_outlined,
            size: 14.sp,
            color: color,
          ),
          SizedBox(width: 6.w),
          Text(
            isOnline ? context.loc.onlineCall : context.loc.inPerson,
            style: context.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isOnline ? AppColors.midnightBlue : AppColors.slateGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(
    BuildContext context,
    bool isUpcoming,
    bool isCancelled,
  ) {
    Color color;
    Color bgColor;
    String text;

    if (isCancelled) {
      color = AppColors.error;
      bgColor = AppColors.error.withValues(alpha: 0.1);
      text = context.loc.cancelled;
    } else if (isUpcoming) {
      color = AppColors.warning;
      bgColor = AppColors.warning.withValues(alpha: 0.1);
      text = context.loc.upcoming;
    } else {
      color = AppColors.slateGray;
      bgColor = AppColors.slateGray.withValues(alpha: 0.1);
      text = context.loc.finished;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: context.radius.medium.radius,
      ),
      child: Text(
        text,
        style: context.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
