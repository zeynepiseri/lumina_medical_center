import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/booking/booking_bloc.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/booking/booking_components.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/booking/consultation_type_selector.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/booking/date_strip.dart';
import 'package:lumina_medical_center/features/appointment/presentation/widgets/booking/time_slot_grid.dart';
import 'package:lumina_medical_center/features/find_doctor/domain/entities/doctor_entity.dart';
import 'package:lumina_medical_center/injection_container.dart';

class BookingSheet extends StatelessWidget {
  final DoctorEntity doctor;
  final int? appointmentId;

  const BookingSheet({super.key, required this.doctor, this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BookingBloc>()
        ..add(
          LoadBookingSlots(doctorId: doctor.id, appointmentId: appointmentId),
        ),
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state.status == BookingStatus.success) {
            Navigator.pop(context, true);
          } else if (state.status == BookingStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? context.loc.anErrorHasOccurred,
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: _BookingSheetView(doctor: doctor, appointmentId: appointmentId),
      ),
    );
  }
}

class _BookingSheetView extends StatelessWidget {
  final DoctorEntity doctor;
  final int? appointmentId;

  const _BookingSheetView({required this.doctor, this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state.status == BookingStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          height: context.height * 0.85,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointmentId != null
                            ? context.loc.rescheduleAppointment
                            : context.loc.bookAppointment,
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.midnightBlue,
                        ),
                      ),
                      context.vSpaceL,

                      BookingTabs(
                        selectedIndex: state.selectedTabIndex,
                        onTabSelected: (index) {
                          context.read<BookingBloc>().add(
                            ChangeAppointmentType(index),
                          );
                        },
                      ),
                      context.vSpaceL,

                      DateStrip(
                        dates: state.next14Days,
                        selectedIndex: state.selectedDateIndex,
                        doctor: doctor,
                        onDateSelected: (date) =>
                            context.read<BookingBloc>().add(SelectDate(date)),
                      ),

                      context.vSpaceL,

                      if (state.selectedDate != null)
                        TimeSlotGrid(
                          selectedDate: state.selectedDate!,
                          doctor: doctor,
                          bookedSlots: state.bookedSlots,
                          selectedTime: state.selectedTime,
                          onTimeSelected: (time) =>
                              context.read<BookingBloc>().add(SelectTime(time)),
                        )
                      else
                        Center(child: Text(context.loc.selectDateFirst)),

                      if (state.selectedTabIndex == 1) ...[
                        context.vSpaceL,
                        BookingSectionTitle(
                          title: context.loc.consultationType,
                        ),
                        context.vSpaceM,

                        ConsultationTypeSelector(
                          selectedIndex: state.selectedConsultationIndex,
                          onSelected: (index) => context
                              .read<BookingBloc>()
                              .add(ChangeConsultationMethod(index)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              _buildBottomBar(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.slateGray.withValues(alpha: 0.1)),
        ),
      ),
      child: Center(
        child: Container(
          width: 40.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: AppColors.slateGray.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, BookingState state) {
    final bool isOnline = state.selectedTabIndex == 1;

    final bool isValid =
        state.selectedTime != null &&
        (!isOnline || state.selectedConsultationIndex != -1);

    final String buttonText = appointmentId != null
        ? context.loc.confirmReschedule
        : context.loc.confirmBooking;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        context.spacing.l.w,
        context.spacing.m.h,
        context.spacing.l.w,
        bottomPadding + context.spacing.m.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.slateGray.withValues(alpha: 0.1)),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: isValid
              ? () {
                  context.read<BookingBloc>().add(
                    ConfirmBooking(
                      doctor: doctor,
                      appointmentId: appointmentId,
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.midnightBlue,
            disabledBackgroundColor: AppColors.slateGray.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: context.radius.large.radius,
            ),
            elevation: 0,
          ),
          child: state.status == BookingStatus.submitting
              ? SizedBox(
                  height: 24.h,
                  width: 24.w,
                  child: const CircularProgressIndicator(
                    color: AppColors.white,
                  ),
                )
              : Text(
                  buttonText,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

class BookingSectionTitle extends StatelessWidget {
  final String title;
  const BookingSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.midnightBlue,
        fontSize: 18.sp,
      ),
    );
  }
}
