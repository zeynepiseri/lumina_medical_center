import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/admin/domain/entities/admin_doctor_entity.dart';

class AppointmentFilterCard extends StatelessWidget {
  final List<AdminDoctorEntity> doctors;
  final DateTime? selectedDate;
  final String? selectedStatus;
  final int? selectedDoctorId;
  final Function(DateTime?) onDateChanged;
  final Function(String?) onStatusChanged;
  final Function(int?) onDoctorChanged;
  final VoidCallback onClearFilters;

  const AppointmentFilterCard({
    super.key,
    required this.doctors,
    this.selectedDate,
    this.selectedStatus,
    this.selectedDoctorId,
    required this.onDateChanged,
    required this.onStatusChanged,
    required this.onDoctorChanged,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.paddingAllM,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: context.radius.large.radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.midnightBlue.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.loc.filterAppointments,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.midnightBlue,
                ),
              ),
              if (selectedDate != null ||
                  selectedStatus != null ||
                  selectedDoctorId != null)
                TextButton.icon(
                  onPressed: onClearFilters,
                  icon: Icon(Icons.clear, size: context.layout.iconSmall),
                  label: Text(context.loc.clear),
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                ),
            ],
          ),
          context.vSpaceM,
          Wrap(
            spacing: context.spacing.m.w,
            runSpacing: context.spacing.m.h,
            children: [
              SizedBox(
                width: 200.w,
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      onDateChanged(date);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: context.loc.date,
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.spacing.s.w,
                        vertical: context.spacing.s.h,
                      ),
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        size: 18.w,
                        color: AppColors.slateGray,
                      ),
                    ),
                    child: Text(
                      selectedDate != null
                          ? DateFormat('dd MMM yyyy').format(selectedDate!)
                          : context.loc.allDates,
                      style: context.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: 200.w,
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: InputDecoration(
                    labelText: context.loc.status,
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.spacing.s.w,
                      vertical: context.spacing.s.h,
                    ),
                  ),
                  items: ['Pending', 'Confirmed', 'Completed', 'Cancelled'].map(
                    (status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(_mapStatusToText(context, status)),
                      );
                    },
                  ).toList(),
                  onChanged: onStatusChanged,
                ),
              ),

              SizedBox(
                width: 250.w,
                child: DropdownButtonFormField<int>(
                  value: selectedDoctorId,
                  decoration: InputDecoration(
                    labelText: context.loc.doctorColumn,
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.spacing.s.w,
                      vertical: context.spacing.s.h,
                    ),
                  ),
                  items: doctors.map((doc) {
                    return DropdownMenuItem<int>(
                      value: doc.id,
                      child: Text(
                        doc.fullName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: onDoctorChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _mapStatusToText(BuildContext context, String status) {
    switch (status) {
      case 'Pending':
        return context.loc.pending;
      case 'Confirmed':
        return context.loc.confirmed;
      case 'Completed':
        return context.loc.completed;
      case 'Cancelled':
        return context.loc.cancelled;
      default:
        return status;
    }
  }
}
