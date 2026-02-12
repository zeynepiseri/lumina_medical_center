import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';

import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';

class AppointmentConfirmationDialog extends StatefulWidget {
  final DoctorEntity doctor;
  final DateTime selectedDate;
  final String selectedTime;
  final String appointmentType;
  final String? consultationMethod;
  final Function(String healthIssue) onConfirm;

  const AppointmentConfirmationDialog({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedTime,
    required this.appointmentType,
    required this.consultationMethod,
    required this.onConfirm,
  });

  @override
  State<AppointmentConfirmationDialog> createState() =>
      _AppointmentConfirmationDialogState();
}

class _AppointmentConfirmationDialogState
    extends State<AppointmentConfirmationDialog> {
  final TextEditingController _issueController = TextEditingController();

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String typeDisplay = widget.appointmentType;
    if (widget.consultationMethod != null &&
        widget.consultationMethod!.isNotEmpty) {
      typeDisplay += " : ${widget.consultationMethod}";
    } else if (widget.appointmentType == "In-Person") {
      typeDisplay += " ${context.loc.inPersonVisit}";
    }

    IconData typeIcon = widget.appointmentType == "Online"
        ? Icons.laptop_mac
        : Icons.person_pin_circle;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radius.xl),
      ),
      backgroundColor: context.colors.surface,
      child: Padding(
        padding: context.paddingAllL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.loc.appointmentConfirmation,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            context.vSpaceL,
            Container(
              width: double.infinity,
              padding: context.paddingAllM,
              decoration: BoxDecoration(
                color: AppColors.alto.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(context.radius.large),
              ),
              child: Column(
                children: [
                  Text(
                    widget.selectedTime,
                    style: context.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                    ),
                  ),
                  Text(
                    DateFormat('dd.MM.yyyy').format(widget.selectedDate),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            context.vSpaceL,
            _buildInfoRow(context, typeIcon, typeDisplay),
            _buildInfoRow(
              context,
              Icons.medical_services,
              widget.doctor.specialty,
            ),
            _buildInfoRow(context, Icons.person, widget.doctor.fullName),

            context.vSpaceL,
            TextField(
              controller: _issueController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.health_and_safety,
                  color: context.colors.secondary,
                ),
                hintText: context.loc.healthIssueOptional,
                filled: true,
                fillColor: AppColors.alto.withValues(alpha: 0.2),
                contentPadding: context.paddingHorizontalM,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.radius.medium),
                  borderSide: BorderSide(color: context.colors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.radius.medium),
                  borderSide: BorderSide(
                    color: context.colors.primary.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),

            context.vSpaceXL,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.secondary,
                      foregroundColor: context.colors.surface,
                      padding: context.paddingVerticalM,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          context.radius.medium,
                        ),
                      ),
                    ),
                    child: Text(
                      context.loc.cancel,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.surface,
                      ),
                    ),
                  ),
                ),
                context.hSpaceM,
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onConfirm(_issueController.text);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.surface,
                      padding: context.paddingVerticalM,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          context.radius.medium,
                        ),
                      ),
                    ),
                    child: Text(
                      context.loc.confirm,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.surface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.s),
      child: Row(
        children: [
          Icon(icon, color: context.colors.primary, size: 20),
          context.hSpaceS,
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
