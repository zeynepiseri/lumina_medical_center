import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/extensions/color_extensions.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/booking_sheet.dart';

class DoctorActionButtons extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorActionButtons({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SizedBox(
            height: context.layout.buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => BookingSheet(doctor: doctor),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.secondary,
                foregroundColor: context.colors.primary,
                elevation: context.spacing.s,
                shadowColor: context.colors.secondary.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.radius.large),
                ),
              ),
              child: Text(
                context.loc.bookAppointment,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
              ),
            ),
          ),
        ),
        context.hSpaceM,
        _buildSoftIconButton(
          context,
          Icons.videocam_rounded,
          context.colors.primary,
        ),
        context.hSpaceS,
        _buildSoftIconButton(
          context,
          Icons.chat_bubble_rounded,
          context.colors.primary,
        ),
      ],
    );
  }

  Widget _buildSoftIconButton(
    BuildContext context,
    IconData icon,
    Color color,
  ) {
    return Container(
      height: context.layout.buttonHeight,
      width: context.layout.buttonHeight,
      decoration: BoxDecoration(
        color: context.colors.surface.darken(0.05),
        borderRadius: BorderRadius.circular(context.radius.large),
      ),
      child: Icon(icon, color: color, size: context.layout.iconMedium),
    );
  }
}
