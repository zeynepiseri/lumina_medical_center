import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';

class AppointmentTable extends StatelessWidget {
  final List<AppointmentEntity> appointments;
  final Function(int) onDelete;

  const AppointmentTable({
    super.key,
    required this.appointments,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Padding(
          padding: context.paddingAllL,
          child: Column(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 64.w,
                color: AppColors.slateGray.withValues(alpha: 0.3),
              ),
              context.vSpaceM,
              Text(
                context.loc.noAppointmentsFound,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.slateGray,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
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
      child: ClipRRect(
        borderRadius: context.radius.large.radius,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: context.width - 64.w),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AppColors.slateGray.withValues(alpha: 0.05),
              ),
              dataRowMinHeight: 60.h,
              dataRowMaxHeight: 80.h,
              horizontalMargin: 24.w,
              columnSpacing: 24.w,
              columns: [
                DataColumn(label: Text(context.loc.patientColumn)),
                DataColumn(label: Text(context.loc.doctorColumn)),
                DataColumn(label: Text(context.loc.dateTimeColumn)),
                DataColumn(label: Text(context.loc.typeColumn)),
                DataColumn(label: Text(context.loc.statusColumn)),
                DataColumn(label: Text(context.loc.actionsColumn)),
              ],
              rows: appointments.map((appt) {
                final date =
                    DateTime.tryParse(appt.appointmentTime) ?? DateTime.now();

                return DataRow(
                  cells: [
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            appt.patientName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    DataCell(Text(appt.doctorName)),
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('dd MMM yyyy').format(date),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            DateFormat('HH:mm').format(date),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.slateGray,
                            ),
                          ),
                        ],
                      ),
                    ),

                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing.s.w,
                          vertical: context.spacing.xs.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: context.radius.small.radius,
                        ),
                        child: Text(
                          appt.appointmentType,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(_buildStatusBadge(context, appt.status)),
                    DataCell(
                      IconButton(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: AppColors.error,
                        ),
                        onPressed: () => onDelete(appt.id),
                        tooltip: context.loc.cancelAppointmentTooltip,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    Color color;
    String label;
    switch (status.toLowerCase()) {
      case 'confirmed':
        color = AppColors.success;
        label = context.loc.confirmed;
        break;
      case 'pending':
        color = AppColors.warning;
        label = context.loc.pending;
        break;
      case 'cancelled':
        color = AppColors.error;
        label = context.loc.cancelled;
        break;
      case 'completed':
        color = AppColors.primary;
        label = context.loc.completed;
        break;
      default:
        color = AppColors.slateGray;
        label = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.s.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: context.radius.large.radius,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
