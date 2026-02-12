import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/base_screen.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_bloc.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_event.dart'
    as action_event;
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_state.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/appointment_event.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/appointment_state.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/appointment_card.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/booking_sheet.dart';
import 'package:lumina_medical_center/features/find_doctor/data/datasources/doctor_service.dart';
import 'package:lumina_medical_center/injection_container.dart';

class MyAppointmentsPage extends StatelessWidget {
  const MyAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AppointmentBloc>()..add(LoadAppointmentsEvent()),
        ),
        BlocProvider(create: (_) => sl<AppointmentActionBloc>()),
      ],
      child: const _MyAppointmentsView(),
    );
  }
}

class _MyAppointmentsView extends StatelessWidget {
  const _MyAppointmentsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentActionBloc, AppointmentActionState>(
      listener: (context, state) {
        if (state is ActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );

          context.read<AppointmentBloc>().add(LoadAppointmentsEvent());
        } else if (state is ActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: BaseScreen(
        backgroundColor: AppColors.background,
        topBarColor: AppColors.background,
        body: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              context.loc.myAppointments,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.midnightBlue,
                fontSize: 20.sp,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, state) {
              if (state.status == AppointmentStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == AppointmentStatus.failure) {
                return Center(
                  child: Text(
                    state.errorMessage ?? context.loc.anErrorHasOccurred,
                  ),
                );
              }

              final allAppointments = [
                ...state.upcomingAppointments,
                ...state.pastAppointments,
              ];

              if (allAppointments.isEmpty) {
                return Center(child: Text(context.loc.noAppointmentsFound));
              }

              return RefreshIndicator(
                onRefresh: () async => context.read<AppointmentBloc>().add(
                  LoadAppointmentsEvent(),
                ),
                child: ListView.separated(
                  padding: context.paddingAllL,
                  itemCount: allAppointments.length,
                  separatorBuilder: (_, __) => context.vSpaceM,
                  itemBuilder: (context, index) {
                    return AppointmentCard(
                      appointment: allAppointments[index],
                      onCancel: () =>
                          _handleCancel(context, allAppointments[index]),
                      onReschedule: () =>
                          _handleReschedule(context, allAppointments[index]),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleCancel(BuildContext context, AppointmentEntity appointment) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.loc.cancelAppointment),
        content: Text(context.loc.cancelDialogBodyLong),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.loc.keep),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);

              context.read<AppointmentActionBloc>().add(
                action_event.CancelAppointmentEvent(appointment.id.toString()),
              );
            },
            child: Text(context.loc.yesCancel),
          ),
        ],
      ),
    );
  }

  Future<void> _handleReschedule(
    BuildContext context,
    AppointmentEntity appointment,
  ) async {
    try {
      final fullDoctor = await sl<DoctorService>().getDoctorById(
        appointment.doctorId,
      );

      if (!context.mounted) return;

      final result = await showModalBottomSheet<bool>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) =>
            BookingSheet(doctor: fullDoctor, appointmentId: appointment.id),
      );

      if (result == true && context.mounted) {
        context.read<AppointmentActionBloc>().add(
          action_event.NotifyAppointmentUpdated(
            context.loc.appointmentRescheduledSuccess,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.loc.errorWithDetails(e.toString()))),
        );
      }
    }
  }
}
