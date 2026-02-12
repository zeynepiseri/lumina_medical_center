import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';
import '../admin_form_section.dart';

class CommonScheduleManager extends StatefulWidget {
  final List<Map<String, dynamic>> schedules;
  final Function(Map<String, dynamic>) onAddSchedule;
  final Function(int) onRemoveSchedule;

  const CommonScheduleManager({
    super.key,
    required this.schedules,
    required this.onAddSchedule,
    required this.onRemoveSchedule,
  });

  @override
  State<CommonScheduleManager> createState() => _CommonScheduleManagerState();
}

class _CommonScheduleManagerState extends State<CommonScheduleManager> {
  String _selectedDay = 'MONDAY';
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);

  final List<String> _days = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  void _handleAdd() {
    final startStr =
        '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
    final endStr =
        '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';

    widget.onAddSchedule({
      'dayOfWeek': _selectedDay,
      'startTime': startStr,
      'endTime': endStr,
    });
  }

  String _getDayName(AppLocalizations l10n, String dayKey) {
    switch (dayKey) {
      case 'MONDAY':
        return l10n.monday;
      case 'TUESDAY':
        return l10n.tuesday;
      case 'WEDNESDAY':
        return l10n.wednesday;
      case 'THURSDAY':
        return l10n.thursday;
      case 'FRIDAY':
        return l10n.friday;
      case 'SATURDAY':
        return l10n.saturday;
      case 'SUNDAY':
        return l10n.sunday;
      default:
        return dayKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;

    return AdminFormSection(
      title: l10n.workSchedule,
      children: [
        Row(
          children: [
            Expanded(flex: 2, child: _buildDropdown(l10n)),
            context.hSpaceS,
            Expanded(child: _buildTimePickerBox(_startTime, true)),
            context.hSpaceS,
            Expanded(child: _buildTimePickerBox(_endTime, false)),
            context.hSpaceS,
            InkWell(
              onTap: _handleAdd,
              borderRadius: context.radius.medium.radius,
              child: Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: context.radius.medium.radius,
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: AppColors.white,
                  size: 24.sp,
                ),
              ),
            ),
          ],
        ),

        context.vSpaceM,

        if (widget.schedules.isEmpty)
          Padding(
            padding: context.paddingVerticalM,
            child: Text(
              l10n.noSchedulesAddedYet,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.slateGray.withValues(alpha: 0.7),
              ),
            ),
          )
        else
          Column(
            children: widget.schedules.asMap().entries.map((entry) {
              final index = entry.key;
              final sch = entry.value;
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.alto),
                  borderRadius: context.radius.medium.radius,
                ),
                child: ListTile(
                  dense: true,
                  leading: Icon(
                    Icons.schedule,
                    color: AppColors.oldGold,
                    size: 20.sp,
                  ),
                  title: Text(
                    _getDayName(l10n, sch['dayOfWeek']),
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text("${sch['startTime']} - ${sch['endTime']}"),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                      size: 20.sp,
                    ),
                    onPressed: () => widget.onRemoveSchedule(index),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildDropdown(AppLocalizations l10n) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: context.radius.medium.radius,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedDay,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.midnightBlue,
            size: context.layout.iconSmall,
          ),
          items: _days
              .map(
                (d) => DropdownMenuItem(
                  value: d,
                  child: Text(
                    _getDayName(l10n, d),
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) => setState(() => _selectedDay = val!),
        ),
      ),
    );
  }

  Widget _buildTimePickerBox(TimeOfDay time, bool isStart) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
          builder: (context, child) {
            return Theme(
              data: context.theme.copyWith(
                colorScheme: context.colors.copyWith(
                  primary: AppColors.midnightBlue,
                  onPrimary: AppColors.white,
                  surface: AppColors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() => isStart ? _startTime = picked : _endTime = picked);
        }
      },
      borderRadius: context.radius.medium.radius,
      child: Container(
        height: 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: context.radius.medium.radius,
        ),
        child: Text(
          '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.midnightBlue,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
