import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';

class AdminRecentAppointmentsTable extends StatelessWidget {
  final List<AppointmentEntity> appointments;

  const AdminRecentAppointmentsTable({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Padding(
          padding: context.paddingAllM,
          child: Text(
            context.loc.noRecentAppointments,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.slateGray,
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20.w,
        horizontalMargin: 12.w,
        columns: [
          DataColumn(label: Text(context.loc.patientColumn)),
          DataColumn(label: Text(context.loc.doctorColumn)),
          DataColumn(label: Text(context.loc.date)),
          DataColumn(label: Text(context.loc.statusColumn)),
        ],
        rows: appointments.take(5).map((appt) {
          final date =
              DateTime.tryParse(appt.appointmentTime) ?? DateTime.now();

          return DataRow(
            cells: [
              DataCell(
                Text(
                  appt.patientName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),

              DataCell(Text(appt.doctorName)),
              DataCell(Text(DateFormat('dd MMM').format(date))),
              DataCell(
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing.s.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(appt.status).withValues(alpha: 0.1),
                    borderRadius: context.radius.medium.radius,
                  ),
                  child: Text(
                    _mapStatusText(context, appt.status),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(appt.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.error;
      case 'completed':
        return AppColors.primary;
      default:
        return AppColors.slateGray;
    }
  }

  String _mapStatusText(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return context.loc.confirmed;
      case 'pending':
        return context.loc.pending;
      case 'cancelled':
        return context.loc.cancelled;
      case 'completed':
        return context.loc.completed;
      default:
        return status;
    }
  }
}
