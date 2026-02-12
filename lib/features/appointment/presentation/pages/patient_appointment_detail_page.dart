import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_bloc.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_event.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_state.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/appointment_action_buttons.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/appointment_card.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/appointment_time_card.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/booking_sheet.dart';
import 'package:lumina_medical_center/features/find_doctor/data/datasources/doctor_service.dart';
import 'package:lumina_medical_center/injection_container.dart';

class PatientAppointmentDetailDialog extends StatefulWidget {
  final AppointmentEntity appointment;

  const PatientAppointmentDetailDialog({super.key, required this.appointment});

  @override
  State<PatientAppointmentDetailDialog> createState() =>
      _PatientAppointmentDetailDialogState();
}

class _PatientAppointmentDetailDialogState
    extends State<PatientAppointmentDetailDialog> {
  Future<void> _onCancelPressed(BuildContext blocContext) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: context.radius.xl.radius),
        title: Text(context.loc.cancelAppointment),
        content: Text(context.loc.cancelDialogBodyLong),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.loc.keep),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            child: Text(context.loc.yesCancel),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final idToSend = widget.appointment.id.toString();
      blocContext.read<AppointmentActionBloc>().add(
        CancelAppointmentEvent(idToSend),
      );
    }
  }

  Future<void> _onReschedulePressed(BuildContext blocContext) async {
    final doctorId = widget.appointment.doctorId;
    final appointmentId = widget.appointment.id;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final fullDoctor = await sl<DoctorService>().getDoctorById(doctorId);

      if (!mounted) return;
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      final result = await showModalBottomSheet<bool>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) =>
            BookingSheet(doctor: fullDoctor, appointmentId: appointmentId),
      );

      if (result == true && mounted) {
        blocContext.read<AppointmentActionBloc>().add(
          NotifyAppointmentUpdated(context.loc.appointmentUpdated),
        );
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.loc.fetchDoctorError(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? parsedDate = DateTime.tryParse(
      widget.appointment.appointmentTime,
    );

    final bool isOnline = widget.appointment.appointmentType
        .toLowerCase()
        .contains('online');

    return BlocProvider(
      create: (context) => sl<AppointmentActionBloc>(),
      child: BlocConsumer<AppointmentActionBloc, AppointmentActionState>(
        listener: (context, state) {
          if (state is ActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is ActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is ActionLoading;

          return Dialog(
            backgroundColor: AppColors.background,
            insetPadding: context.paddingHorizontalM,
            shape: RoundedRectangleBorder(
              borderRadius: context.radius.large.radius,
            ),
            child: SingleChildScrollView(
              padding: context.paddingAllM,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.loc.appointmentDetails,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.midnightBlue,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.slateGray,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  context.vSpaceM,

                  AppointmentCard(appointment: widget.appointment),
                  context.vSpaceM,

                  AppointmentTimeCard(date: parsedDate),
                  context.vSpaceL,

                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    AppointmentActionButtons(
                      isOnline: isOnline,
                      onCancel: () => _onCancelPressed(context),
                      onReschedule: () => _onReschedulePressed(context),
                      onVideoCall: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.loc.videoCallComingSoon),
                          ),
                        );
                      },
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
