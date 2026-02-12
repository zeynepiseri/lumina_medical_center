import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_bloc.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_event.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_state.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/patient_info_card.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/appointment_time_card.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/complaint_detail_card.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/appointment_action_buttons.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/booking_sheet.dart';
import 'package:lumina_medical_center/features/find_doctor/data/datasources/doctor_service.dart';
import 'package:lumina_medical_center/injection_container.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';

class DoctorAppointmentDetailPage extends StatefulWidget {
  final AppointmentEntity appointment;

  const DoctorAppointmentDetailPage({super.key, required this.appointment});

  @override
  State<DoctorAppointmentDetailPage> createState() =>
      _DoctorAppointmentDetailPageState();
}

class _DoctorAppointmentDetailPageState
    extends State<DoctorAppointmentDetailPage> {
  Future<void> _onCancelPressed() async {
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
      context.read<AppointmentActionBloc>().add(
        CancelAppointmentEvent(idToSend),
      );
    }
  }

  Future<void> _onReschedulePressed() async {
    final doctorId = widget.appointment.doctorId;

    final appointmentId = widget.appointment.id;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final fullDoctor = await sl<DoctorService>().getDoctorById(doctorId);
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (!mounted) return;
      final result = await showModalBottomSheet<bool>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: AppColors.transparent,
        builder: (ctx) =>
            BookingSheet(doctor: fullDoctor, appointmentId: appointmentId),
      );
      if (result == true && mounted) {
        context.read<AppointmentActionBloc>().add(
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
    final patientName = widget.appointment.patientName.isEmpty
        ? context.loc.unknownPatient
        : widget.appointment.patientName;

    final healthIssue = widget.appointment.healthIssue.isEmpty
        ? context.loc.noDetails
        : widget.appointment.healthIssue;

    final rawType = widget.appointment.appointmentType;
    final bool isOnline = rawType.toLowerCase().contains("online");
    final displayType = isOnline
        ? context.loc.onlineConsultation
        : context.loc.inPersonVisit;

    final DateTime? parsedDate = DateTime.tryParse(
      widget.appointment.appointmentTime,
    );

    return BlocListener<AppointmentActionBloc, AppointmentActionState>(
      listener: (context, state) {
        if (state is ActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );
          if (mounted && GoRouter.of(context).canPop()) {
            context.pop(true);
          }
        } else if (state is ActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
            onPressed: () => context.pop(),
          ),
          title: Text(
            context.loc.appointmentDetails,
            style: context.textTheme.headlineMedium?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: context.paddingAllL,
          child: Column(
            children: [
              PatientInfoCard(
                name: patientName,
                type: displayType,
                isOnline: isOnline,
              ),
              context.vSpaceXL,

              AppointmentTimeCard(date: parsedDate),
              context.vSpaceXL,
              ComplaintDetailCard(healthIssue: healthIssue),
              context.vSpaceXXL,

              AppointmentActionButtons(
                isOnline: isOnline,
                onCancel: _onCancelPressed,
                onReschedule: _onReschedulePressed,
                onVideoCall: () {},
              ),
              context.vSpaceL,
            ],
          ),
        ),
      ),
    );
  }
}
