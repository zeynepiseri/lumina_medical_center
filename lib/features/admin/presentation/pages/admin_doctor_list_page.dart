import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/admin/domain/usecases/get_all_doctors_usecase.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_doctor_list/admin_doctor_list_cubit.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_doctor_list/admin_doctor_list_state.dart';
import 'package:lumina_medical_center/features/admin/presentation/widgets/doctor_list_table.dart';
import 'package:lumina_medical_center/injection_container.dart';

class AdminDoctorListPage extends StatelessWidget {
  const AdminDoctorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AdminDoctorListCubit(sl<GetAllDoctorsUseCase>())..loadDoctors(),
      child: const _AdminDoctorListView(),
    );
  }
}

class _AdminDoctorListView extends StatelessWidget {
  const _AdminDoctorListView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminDoctorListCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          context.loc.selectDoctorToEdit,
          style: context.textTheme.titleLarge?.copyWith(
            color: AppColors.midnightBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.midnightBlue),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: context.spacing.l.w),
            child: ElevatedButton.icon(
              onPressed: () async {
                await context.push('/admin-dashboard/add-doctor');
                if (context.mounted) cubit.loadDoctors();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.oldGold,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: context.spacing.m.w,
                  vertical: context.spacing.s.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: context.radius.medium.radius,
                ),
              ),
              icon: Icon(Icons.add, size: context.layout.iconSmall),
              label: Text(
                context.loc.addDoctorTitle,
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: context.pagePadding,
        child: Column(
          children: [
            Container(
              padding: context.paddingHorizontalM,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: context.radius.large.radius,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.midnightBlue.withValues(
                      alpha: context.opacity.faint,
                    ),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                onChanged: cubit.filterDoctors,
                style: context.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: context.loc.searchDoctorHint,
                  hintStyle: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.slateGray.withValues(alpha: 0.5),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.midnightBlue,
                    size: context.layout.iconMedium,
                  ),
                  border: InputBorder.none,
                  contentPadding: context.paddingVerticalM,
                ),
              ),
            ),
            context.vSpaceL,
            Expanded(
              child: BlocBuilder<AdminDoctorListCubit, AdminDoctorListState>(
                builder: (context, state) {
                  if (state.status == DoctorListStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == DoctorListStatus.failure) {
                    return Center(
                      child: Text(
                        state.errorMessage ?? context.loc.anErrorHasOccurred,
                      ),
                    );
                  } else if (state.filteredDoctors.isEmpty) {
                    return Center(
                      child: Text(
                        context.loc.noDoctorsFound,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.slateGray,
                        ),
                      ),
                    );
                  }

                  return DoctorListTable(
                    doctors: state.filteredDoctors,
                    onRefresh: cubit.loadDoctors,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
