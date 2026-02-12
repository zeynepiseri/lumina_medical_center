import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_bloc.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_state.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/doctor_dashboard_bloc.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/bloc/doctor_dashboard_event.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/widgets/dashboard_calendar.dart';
import 'package:lumina_medical_center/features/doctor_dashboard/presentation/widgets/appointment_list_section.dart';

class DoctorDashboardPage extends StatefulWidget {
  const DoctorDashboardPage({super.key});

  @override
  State<DoctorDashboardPage> createState() => _DoctorDashboardPageState();
}

class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchAppointments(_selectedDate);
  }

  void _fetchAppointments(DateTime date) {
    context.read<DashboardBloc>().add(LoadAppointmentsByDate(date));
  }

  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
    _fetchAppointments(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: BlocListener<AppointmentActionBloc, AppointmentActionState>(
        listener: (context, state) {
          if (state is ActionSuccess) {
            context.read<DashboardBloc>().add(
              LoadAppointmentsByDate(_selectedDate, forceRefresh: true),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: CustomScrollView(
          slivers: [
            const DashboardAppBar(),
            SliverToBoxAdapter(
              child: DashboardCalendar(
                selectedDate: _selectedDate,
                onDateSelected: _onDateSelected,
              ),
            ),
            SliverToBoxAdapter(child: context.vSpaceL),
            const AppointmentListSection(),
            SliverToBoxAdapter(child: context.vSpaceXXL),
          ],
        ),
      ),
    );
  }
}
