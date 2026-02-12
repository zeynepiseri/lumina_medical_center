import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';

extension AppointmentUIExtension on AppointmentEntity {
  bool get isPast {
    final date = DateTime.tryParse(appointmentTime);
    if (date == null) return false;
    return date.isBefore(DateTime.now());
  }

  Color get statusColor {
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

  IconData get typeIcon {
    if (appointmentType == 'Online') {
      return Icons.videocam_outlined;
    }
    return Icons.person_pin_circle_outlined;
  }

  String get typeLabel {
    if (appointmentType == 'Online') {
      return 'Video Call';
    }
    return 'In-Person';
  }
}
