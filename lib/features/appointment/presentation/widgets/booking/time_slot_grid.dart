import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/utils/time_slot_generator.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';

class TimeSlotGrid extends StatelessWidget {
  final DateTime selectedDate;
  final DoctorEntity doctor;
  final List<DateTime> bookedSlots;
  final String? selectedTime;
  final ValueChanged<String> onTimeSelected;

  const TimeSlotGrid({
    super.key,
    required this.selectedDate,
    required this.doctor,
    required this.bookedSlots,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat compareFormat = DateFormat('yyyy-MM-dd HH:mm');

    final dayName = DateFormat('EEEE').format(selectedDate).toUpperCase();
    final now = DateTime.now();

    List<String> times = [];
    try {
      final schedule = doctor.schedules.firstWhere(
        (s) => s.dayOfWeek == dayName,
      );
      final startHour = int.parse(schedule.startTime.split(':')[0]);
      final endHour = int.parse(schedule.endTime.split(':')[0]);

      times = TimeSlotGenerator.generate(
        startHour: startHour,
        endHour: endHour,
        intervalMinutes: 30,
      );
    } catch (e) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.spacing.l.h),
          child: Text(
            context.loc.noScheduleForDay(dayName),
            style: TextStyle(color: AppColors.error),
          ),
        ),
      );
    }

    if (times.isEmpty) {
      return Center(child: Text(context.loc.noSlotsAvailable));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.loc.availableTime,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.onSurface,
          ),
        ),
        context.vSpaceM,

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: times.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: context.spacing.s.w,
            mainAxisSpacing: context.spacing.s.h,
          ),
          itemBuilder: (context, index) {
            final timeStr = times[index];
            final parts = timeStr.split(':');
            final hour = int.parse(parts[0]);
            final minute = int.parse(parts[1]);

            final slotDateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              hour,
              minute,
            );

            final slotString = compareFormat.format(slotDateTime);

            final isBookedInDb = bookedSlots.any((booked) {
              final bookedString = compareFormat.format(booked.toLocal());
              return bookedString == slotString;
            });

            final isPastTime = slotDateTime.isBefore(now);
            final isDisabled = isBookedInDb || isPastTime;
            final isSelected = selectedTime == timeStr;

            return GestureDetector(
              onTap: isDisabled ? null : () => onTimeSelected(timeStr),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDisabled
                      ? AppColors.disabled.withValues(alpha: 0.3)
                      : (isSelected
                            ? context.colors.primary
                            : context.colors.surface),
                  borderRadius: BorderRadius.circular(context.radius.large),
                  border: Border.all(
                    color: isSelected ? context.colors.primary : AppColors.alto,
                  ),
                ),
                child: Text(
                  timeStr,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isDisabled
                        ? AppColors.textSecondary
                        : (isSelected
                              ? AppColors.white
                              : context.colors.onSurface),
                    decoration: isBookedInDb
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
