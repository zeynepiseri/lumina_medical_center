import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/domain/entities/my_profile_entity.dart';

class ScheduleManagerSection extends StatefulWidget {
  final List<WorkSchedule> schedules;
  final Function(WorkSchedule) onAddSchedule;
  final Function(int) onRemoveSchedule;

  const ScheduleManagerSection({
    super.key,
    required this.schedules,
    required this.onAddSchedule,
    required this.onRemoveSchedule,
  });

  @override
  State<ScheduleManagerSection> createState() => _ScheduleManagerSectionState();
}

class _ScheduleManagerSectionState extends State<ScheduleManagerSection> {
  final List<String> _days = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];
  String _selectedDay = 'MONDAY';
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);

  void _handleAddPressed() {
    final newSchedule = WorkSchedule(
      dayOfWeek: _selectedDay,
      startTime: _formatTime(_startTime),
      endTime: _formatTime(_endTime),
    );
    widget.onAddSchedule(newSchedule);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.loc.workingHoursSection,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
            Icon(
              Icons.access_time,
              color: context.colors.secondary,
              size: 24.sp,
            ),
          ],
        ),
        context.vSpaceL,
        Container(
          padding: context.paddingAllM,
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.05),
            borderRadius: context.radius.large.radius,
            border: Border.all(
              color: context.colors.primary.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedDay,
                items: _days
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedDay = val!),
                decoration: InputDecoration(
                  labelText: context.loc.dayLabel,
                  border: OutlineInputBorder(
                    borderRadius: context.radius.medium.radius,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                ),
              ),
              context.vSpaceM,

              Row(
                children: [
                  Expanded(
                    child: _buildTimeButton(
                      context.loc.startLabel,
                      _startTime,
                      true,
                    ),
                  ),
                  context.hSpaceS,
                  Expanded(
                    child: _buildTimeButton(
                      context.loc.endLabel,
                      _endTime,
                      false,
                    ),
                  ),
                ],
              ),
              context.vSpaceM,

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleAddPressed,
                  icon: const Icon(Icons.add_circle_outline),
                  label: Text(context.loc.addToList),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.surface,
                    padding: context.paddingVerticalM,
                    shape: RoundedRectangleBorder(
                      borderRadius: context.radius.medium.radius,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        context.vSpaceL,
        Text(
          context.loc.currentHours,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        context.vSpaceS,
        widget.schedules.isEmpty
            ? Padding(
                padding: context.paddingAllL,
                child: Center(
                  child: Text(
                    context.loc.noWorkingHoursAdded,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.slateGray,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.schedules.length,
                itemBuilder: (context, index) {
                  final sch = widget.schedules[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: context.spacing.s.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: context.radius.medium.radius,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: context.colors.secondary.withValues(
                          alpha: 0.2,
                        ),
                        child: Text(
                          (sch.dayOfWeek).substring(0, 3),
                          style: context.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                      title: Text(
                        "${sch.startTime} - ${sch.endTime}",
                        style: context.textTheme.bodyMedium,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: context.colors.error,
                        ),
                        onPressed: () => widget.onRemoveSchedule(index),
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildTimeButton(String label, TimeOfDay time, bool isStart) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          setState(() {
            if (isStart) {
              _startTime = picked;
            } else {
              _endTime = picked;
            }
          });
        }
      },
      borderRadius: context.radius.medium.radius,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.slateGray),
          borderRadius: context.radius.medium.radius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.slateGray,
              ),
            ),
            Text(
              "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
