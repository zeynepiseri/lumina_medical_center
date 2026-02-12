import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/doctor_dashboard_bloc.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/doctor_dashboard_state.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/doctor_dashboard_event.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';

class AppointmentListSection extends StatelessWidget {
  const AppointmentListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is DashboardError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: context.paddingAllM,
                child: Text(
                  "${context.loc.error}: ${state.message}",
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colors.error,
                  ),
                ),
              ),
            ),
          );
        } else if (state is DashboardLoaded) {
          final appointments = state.appointments;

          if (appointments.isEmpty) {
            return SliverToBoxAdapter(child: _buildEmptyState(context));
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final isLast = index == appointments.length - 1;
              final appointment = appointments[index] as AppointmentEntity;

              return _AppointmentTile(
                appointment: appointment,
                isLast: isLast,
                onTap: () async {
                  final result = await context.push(
                    '/doctor-appointment-detail',
                    extra: appointment,
                  );
                  if (result == true && context.mounted) {
                    context.read<DashboardBloc>().add(
                      LoadAppointmentsByDate(state.selectedDate),
                    );
                  }
                },
              );
            }, childCount: appointments.length),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.paddingAllL,
        child: Column(
          children: [
            Icon(
              Icons.calendar_today,
              size: 60,
              color: AppColors.slateGray.withValues(alpha: 0.3),
            ),
            context.vSpaceM,
            Text(
              "No appointments found",
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  final AppointmentEntity appointment;
  final bool isLast;
  final VoidCallback onTap;

  const _AppointmentTile({
    required this.appointment,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final date =
        DateTime.tryParse(appointment.appointmentTime) ?? DateTime.now();
    final patientName = appointment.patientName.isEmpty
        ? context.loc.unknownPatient
        : appointment.patientName;
    final type = appointment.appointmentType;

    final timeStr = DateFormat('HH:mm').format(date);
    final bool isVideo = type.toString().toLowerCase().contains('online');

    return TimelineTile(
      isFirst: false,
      isLast: isLast,
      alignment: TimelineAlign.manual,
      lineXY: 0.2,
      startChild: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: context.spacing.s),
        child: Text(
          timeStr,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.primary.withValues(alpha: 0.8),
          ),
        ),
      ),
      indicatorStyle: IndicatorStyle(
        width: 30,
        height: 30,
        indicator: Container(
          decoration: BoxDecoration(
            color: isVideo ? context.colors.secondary : context.colors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: context.colors.surface, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            isVideo ? Icons.videocam : Icons.person,
            size: 16,
            color: context.colors.surface,
          ),
        ),
      ),
      beforeLineStyle: LineStyle(
        color: AppColors.slateGray.withValues(alpha: 0.3),
        thickness: 2,
      ),
      endChild: Padding(
        padding: EdgeInsets.only(
          left: context.spacing.s,
          bottom: context.spacing.l,
          top: 4,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(context.radius.large),
          child: Container(
            padding: context.paddingAllM,
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(context.radius.large),
              boxShadow: [
                BoxShadow(
                  color: AppColors.slateGray.withValues(alpha: 0.1),
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
                      patientName,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.primary,
                      ),
                    ),
                    if (isVideo)
                      Icon(
                        Icons.video_camera_front,
                        color: context.colors.secondary,
                        size: 20,
                      ),
                  ],
                ),
                context.vSpaceXS,
                Text(
                  type,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.slateGray,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
