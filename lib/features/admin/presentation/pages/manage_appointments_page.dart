import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/base_screen.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_appointment_management/appointment_management_cubit.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_appointment_management/appointment_management_state.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/admin_appointment_management/appointment_filter_card.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/admin_appointment_management/appointment_table.dart';
import 'package:lumina_medical_center/injection_container.dart';

class ManageAppointmentsPage extends StatelessWidget {
  const ManageAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AppointmentManagementCubit>()..loadData(),
      child: const _ManageAppointmentsView(),
    );
  }
}

class _ManageAppointmentsView extends StatelessWidget {
  const _ManageAppointmentsView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppointmentManagementCubit>();

    return BaseScreen(
      backgroundColor: AppColors.background,
      topBarColor: AppColors.background,
      body: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            context.loc.manageAppointmentsTitle,
            style: context.textTheme.titleLarge?.copyWith(
              color: AppColors.midnightBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.midnightBlue),
        ),
        body:
            BlocBuilder<AppointmentManagementCubit, AppointmentManagementState>(
              builder: (context, state) {
                if (state.status == AppointmentManagementStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == AppointmentManagementStatus.failure) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? context.loc.anErrorHasOccurred,
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: context.pagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppointmentFilterCard(
                        doctors: state.doctors,
                        selectedDate: state.selectedDate,
                        selectedStatus: state.selectedStatus,
                        selectedDoctorId: state.selectedDoctorId,
                        onDateChanged: (date) =>
                            cubit.filterAppointments(date: date),
                        onStatusChanged: (status) =>
                            cubit.filterAppointments(status: status),
                        onDoctorChanged: (id) =>
                            cubit.filterAppointments(doctorId: id),
                        onClearFilters: () => cubit.clearFilters(),
                      ),
                      context.vSpaceL,
                      AppointmentTable(
                        appointments: state.filteredAppointments,
                        onDelete: (id) => cubit.cancelAppointment(id),
                      ),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }
}
