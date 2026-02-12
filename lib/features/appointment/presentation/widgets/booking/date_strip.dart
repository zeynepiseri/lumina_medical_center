import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';

class DateStrip extends StatelessWidget {
  final List<DateTime> dates;
  final int selectedIndex;
  final DoctorEntity doctor;
  final Function(DateTime) onDateSelected;

  const DateStrip({
    super.key,
    required this.dates,
    required this.selectedIndex,
    required this.doctor,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.midnightBlue;

    return SizedBox(
      height: 80.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = selectedIndex == index;

          final dayName = DateFormat('EEEE').format(date).toUpperCase();
          final isWorking = doctor.schedules.any((s) => s.dayOfWeek == dayName);

          return GestureDetector(
            onTap: isWorking ? () => onDateSelected(date) : null,
            child: Container(
              width: 60.w,
              margin: EdgeInsets.only(right: context.spacing.s.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor
                    : (isWorking
                          ? AppColors.white
                          : AppColors.alto.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(context.radius.large),
                border: Border.all(
                  color: isSelected ? activeColor : AppColors.alto,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isSelected ? AppColors.white : AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  context.vSpaceXS,
                  Text(
                    date.day.toString(),
                    style: context.textTheme.titleMedium?.copyWith(
                      color: isSelected ? AppColors.white : AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
