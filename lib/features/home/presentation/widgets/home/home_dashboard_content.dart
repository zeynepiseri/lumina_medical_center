import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/appointment/domain/entities/appointment_entity.dart';
import 'package:lumina_medical_center/features/appointment/presentation/pages/patient_appointment_detail_page.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/find_doctor/data/models/doctor_model.dart';
import 'package:lumina_medical_center/features/home/presentation/widgets/doctor/doctor_card.dart';
import 'package:lumina_medical_center/features/home/presentation/widgets/home/section_header.dart';
import 'package:lumina_medical_center/features/home/presentation/widgets/home/specialty_list.dart';
import 'package:lumina_medical_center/features/home/presentation/widgets/home/upcoming_appointment_card.dart';

import '../../../../find_doctor/domain/entities/doctor_entity.dart';

class HomeDashboardContent extends StatelessWidget {
  final List<BranchEntity> categories;
  final AppointmentEntity? upcomingAppointment;
  final List<DoctorEntity> topDoctors;
  final List<DoctorEntity> popularDoctors;
  const HomeDashboardContent({
    super.key,
    required this.categories,
    required this.upcomingAppointment,
    required this.topDoctors,
    required this.popularDoctors,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing.m.w),
            child: SectionHeader(
              title: context.loc.selectBranch,
              onTap: () => context.push('/home/branches'),
            ),
          ),
          context.vSpaceM,
          SpecialtyList(specialties: categories),
          context.vSpaceL,

          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing.m.w),
            child: SectionHeader(
              title: context.loc.upcomingAppointments,
              onTap: () => context.go('/appointments'),
            ),
          ),
          context.vSpaceM,

          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing.m.w),
            child: upcomingAppointment != null
                ? SizedBox(
                    width: double.infinity,
                    child: UpcomingAppointmentCard(
                      appointment: upcomingAppointment!,
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (_) => PatientAppointmentDetailDialog(
                            appointment: upcomingAppointment!,
                          ),
                        );
                      },
                    ),
                  )
                : _buildNoAppointmentWidget(context),
          ),
          context.vSpaceL,

          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing.m.w),
            child: SectionHeader(
              title: context.loc.popularDoctorsTitle,
              onTap: () => context.push('/home/doctors'),
            ),
          ),
          context.vSpaceM,

          SizedBox(
            height: 240.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: topDoctors.length,
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing.m.w,
                vertical: 5.h,
              ),
              separatorBuilder: (context, index) => context.hSpaceM,
              itemBuilder: (context, index) {
                return DoctorCard(doctor: topDoctors[index]);
              },
            ),
          ),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }

  Widget _buildNoAppointmentWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.paddingAllM,
      decoration: BoxDecoration(
        color: AppColors.slateGray.withValues(alpha: 0.1),
        borderRadius: context.radius.large.radius,
        border: Border.all(color: AppColors.slateGray.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy,
            size: 40.sp,
            color: AppColors.slateGray.withValues(alpha: 0.5),
          ),
          context.vSpaceS,
          Text(
            context.loc.noUpcomingAppointments,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.slateGray,
            ),
          ),
          Text(
            context.loc.bookNewAppointment,
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.slateGray,
            ),
          ),
        ],
      ),
    );
  }
}
